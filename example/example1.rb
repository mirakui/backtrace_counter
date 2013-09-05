$: << File.expand_path('../../lib', __FILE__)
require 'backtrace_counter'
require 'pp'

class Foo
  def foo
    'foo'
  end
end

class Bar
  def self.bar
    'bar'
  end
end

BacktraceCounter.set_backtrace_filter {|line| line =~ %r(#{__FILE__}) }
BacktraceCounter.start('Foo#foo', 'Bar#bar') do
  a = Foo.new
  100.times { a.foo }
  200.times { Bar.bar }
end

printer = BacktraceCounter::CsvPrinter.new
printer.print BacktraceCounter.backtraces
