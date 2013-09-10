require "backtrace_counter/version"

module BacktraceCounter
  autoload :Middleware, 'backtrace_counter/middleware'
  autoload :CsvPrinter, 'backtrace_counter/printer/csv_printer'

  module_function

  def start(*methods)
    return warn 'BacktraceCounter is already running' if @trace
    clear
    @trace = trace_point(methods)
    @trace.enable
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

  def stats
    a = @backtraces.values
    a.sort_by! { |item| item[:count] }
    a.reverse!
    a
  end

  def backtraces
    @backtraces
  end

  def clear
    @backtraces = {}
  end

  def set_caller_depth(depth)
    @depth = depth
  end

  def set_backtrace_filter(&block)
    @backtrace_filter = block
  end

  def trace_point(methods)
    get_class = Kernel.instance_method(:class)
    TracePoint.new(:call) do |tp|
      klass = get_class.bind(tp.self).call
      method = if klass == Class || klass == Module
                  "#{tp.self}.##{tp.method_id}"
                else
                  "#{klass}##{tp.method_id}"
                end
      methods.each do |method_to_trace|
        if method_to_trace === method
          record method
          break
        end
      end
    end
  end

  def record(method)
    bt = caller(2, @depth).select(&(@backtrace_filter || -> line { true }))
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
