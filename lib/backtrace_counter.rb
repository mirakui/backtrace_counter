require "backtrace_counter/version"

module BacktraceCounter
  autoload :Middleware, 'backtrace_counter/middleware'
  autoload :CsvPrinter, 'backtrace_counter/printer/csv_printer'

  module_function

  def start(*methods)
    clear
    ::Kernel.set_trace_func trace_func(methods)
    if block_given?
      yield
      stop
    end
  end

  def stop
    set_trace_func nil
  end

  def backtraces
    @backtraces
  end

  def clear
    @backtraces = {}
  end

  def trace_func(methods)
    lambda do |event, file, line, id, binding, klass|
      _method = "#{klass}##{id}"
      next unless event == 'call'
      methods.each do |method|
        if (method.is_a?(Regexp) && _method =~ method) || _method == method
          inc _method, caller(3)
          break
        end
      end
    end
  end

  def inc(method, backtrace)
    bt = filtered_backtrace(backtrace)
    hash = "#{method}/#{bt.hash}"
    backtraces[hash] ||= {
      method: method,
      backtrace: bt,
      count: 0
    }
    backtraces[hash][:count] += 1
  end

  def set_backtrace_filter(&block)
    @backtrace_filter = block
  end

  def filtered_backtrace(backtrace)
    backtrace.select {|line| !@backtrace_filter || @backtrace_filter.call(line) }
  end
end
