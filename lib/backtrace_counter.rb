require "backtrace_counter/version"

module BacktraceCounter
  module_function

  def start(*methods)
    clear
    set_trace_func trace_func(methods)
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
    lambda do |event, file, line, id, binding, _klass|
      next unless event == 'call'
      methods.each do |klass, method_name|
        if _klass.to_s == klass.to_s && id.to_s == method_name.to_s
          inc "#{klass}##{method_name}", caller(3)
          break
        end
      end
    end
  end

  def inc(method, backtrace)
    hash = "#{method}/#{backtrace.hash}"
    backtraces[hash] ||= {
      method: method,
      backtrace: backtrace,
      count: 0
    }
    backtraces[hash][:count] += 1
  end
end
