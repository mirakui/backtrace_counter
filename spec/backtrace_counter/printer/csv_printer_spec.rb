require 'backtrace_counter/printer/csv_printer'

describe BacktraceCounter::CsvPrinter do
  before do
    @output_file = File.expand_path("../tmp-#{Time.now.to_i}-$$.csv", __FILE__)
    BacktraceCounter::CsvPrinter.new(@output_file).print([
      { method: 'foo', count: 20, backtrace: ["abc"] },
      { method: 'bar', count: 10, backtrace: ["xyz"] },
      ])
  end
  after do
    File.unlink @output_file
  end

  it "prints backtraces as CSV" do
    expect(File.read(@output_file)).to eq(<<-END)
foo,20,abc
bar,10,xyz
    END

  end
end
