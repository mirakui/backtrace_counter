module BacktraceCounter
  class Printer
    def initialize(output=$stdout)
      @output = output
    end

    def print(backtraces)
      raise NotImplementedError
    end

    def print_block
      if @output.is_a?(IO)
        yield @output
        @output.flush
      else
        open(@output, 'w+') do |output|
          yield output
        end
      end
    end
  end
end
