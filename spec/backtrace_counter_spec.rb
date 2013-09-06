require 'backtrace_counter'

describe BacktraceCounter do

  describe '.start' do
    describe 'with block' do

      let(:bt) do
        o = Object.new
        def o.foo
          'bar'
        end
        def o.class
          raise 'boom!'
        end
        o

        BacktraceCounter.start /foo/ do
          o.foo
          2.times { o.foo }
        end
        BacktraceCounter.backtraces
      end

      it 'traces 2 method calls' do
        expect(bt.length).to eq(2)
      end

      describe 'with the first item' do
        let(:item) { bt[bt.keys[0]] }
        it 'reports :method is Object#foo' do
          expect(item[:method]).to eq('Object#foo')
        end
        it 'reports :count is 1' do
          expect(item[:count]).to eq(1)
        end
        it 'reports :backtrace is an array with some items' do
          expect(item[:backtrace].length).to be >= 0
        end
      end

      describe 'withn the first item' do
        let(:item) { bt[bt.keys[1]] }
        it ':method is Object#foo' do
          expect(item[:method]).to eq('Object#foo')
        end

        it ':count is 2' do
          expect(item[:count]).to eq(2)
        end
        it 'reports :backtrace is an array with some items' do
          expect(item[:backtrace].length).to be >= 0
        end
      end
    end
  end
end
