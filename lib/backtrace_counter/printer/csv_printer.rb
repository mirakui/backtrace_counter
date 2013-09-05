require 'backtrace_counter/printer'
require 'csv'

module BacktraceCounter
  class CsvPrinter < Printer
    def print(backtraces)
      backtraces.values.each_with_index do |bt, i|
        #@output.write "\n" unless i == 0
        line = CSV.generate_line([
          bt[:method],
          bt[:count],
          filtered_backtrace(bt[:backtrace]).join("\n")
        ])
        @output.write line
      end
      @output.flush
    end
  end
end
