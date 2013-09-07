require "backtrace_counter/version"

module BacktraceCounter
  autoload :Middleware, 'backtrace_counter/middleware'
  autoload :CsvPrinter, 'backtrace_counter/printer/csv_printer'

  module_function

  def start(*methods)
    raise RuntimeError, 'BacktraceCounter is already running' if @trace
    clear
    @trace = TracePoint.trace(:call, &trace_func(methods))
    if block_given?
      begin
        yield
      ensure
        stop
      end
    end
  end

  def stop
    @trace.disable
    @trace = nil
  end

  def backtraces
    @backtraces
  end

  def clear
    @backtraces = {}
  end

  def set_backtrace_filter(&block)
    @backtrace_filter = block
  end

  def filtered_backtrace(backtrace)
    backtrace.select {|line| !@backtrace_filter || @backtrace_filter.call(line) }
  end

  def trace_func(methods)
    get_class = Kernel.instance_method(:class)
    lambda do |tp|
      klass = get_class.bind(tp.self).call
      method = if klass == Class || klass == Module
                  "#{tp.self}.##{tp.method_id}"
                else
                  "#{klass}##{tp.method_id}"
                end
      methods.each do |method_to_trace|
        if method_to_trace === method
          record method, caller(3)
          break
        end
      end
    end
  end

  def record(method, backtrace)
    bt = filtered_backtrace(backtrace)
    return if bt.empty?
    hash = "#{method}/#{bt.hash}"
    backtraces[hash] ||= {
      method: method,
      backtrace: bt,
      count: 0
    }
    backtraces[hash][:count] += 1
  end

end
