require 'backtrace_counter/printer'
require 'csv'

module BacktraceCounter
  class CsvPrinter < Printer
    def print(backtraces)
      print_block do
        backtraces.values.each_with_index do |bt, i|
          line = CSV.generate_line([
            bt[:method],
            bt[:count],
            bt[:backtrace].join("\n")
          ])
          @output.write line
        end
      end
    end
  end
end
