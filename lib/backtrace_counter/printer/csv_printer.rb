require 'backtrace_counter/printer'
require 'csv'

module BacktraceCounter
  class CsvPrinter < Printer
    def print(backtraces)
      print_block do |output|
        backtraces.values.each do |bt|
          output.write CSV.generate_line([
            bt[:method],
            bt[:count],
            bt[:backtrace].join("\n")
          ])
        end
      end
    end
  end
end
