module BacktraceCounter
  class Printer
    def initialize(output=$stdout)
      @backtrace_filter = lambda {|v| true }
      @output = output
    end

    def set_backtrace_filter(&block)
      @backtrace_filter = block
    end

    def print(backtraces)
      raise NotImplementedError
    end

    protected
    def filtered_backtrace(backtrace)
      backtrace.select {|bt| @backtrace_filter.call bt }
    end

    def print_block
      if @output.is_a?(IO)
        yield
        @output.flush
      else
        _output = @output
        @output = open(@output, 'w+')
        yield
        @output.close
        @output = _output
      end
    end
  end
end
