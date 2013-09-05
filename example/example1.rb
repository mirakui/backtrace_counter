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
__END__
> ruby example/example1.rb
Foo#foo,100,"example/example1.rb:6:in `foo'
example/example1.rb:20:in `block (2 levels) in <main>'
example/example1.rb:20:in `times'
example/example1.rb:20:in `block in <main>'
example/example1.rb:18:in `<main>'"
Bar#bar,200,"example/example1.rb:12:in `bar'
example/example1.rb:21:in `block (2 levels) in <main>'
example/example1.rb:21:in `times'
example/example1.rb:21:in `block in <main>'
example/example1.rb:18:in `<main>'"
