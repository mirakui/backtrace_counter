require 'backtrace_counter'

describe BacktraceCounter do
  class Cls
    def instance_method1
    end
    def self.class_method1
    end
    def self.class
      raise 'boom!'
    end
  end
  module Mod
    module_function
    def module_method1
    end
  end

  describe '.start' do
    describe 'with block' do
      before do
        obj = Cls.new
        BacktraceCounter.start /^Cls/, /^Mod/ do
          30.times { obj.instance_method1 }
          20.times { Cls.class_method1 }
          10.times { Mod.module_method1 }
        end
      end
      let (:bt) { BacktraceCounter.stats }

      it { expect(bt.length).to eq(3) }

      describe 'reports instance method' do
        let(:item) { bt[0] }
        it { expect(item[:method]).to eq('Cls#instance_method1') }
        it { expect(item[:count]).to eq(30) }
        it { expect(item[:backtrace].length).to be > 0 }
      end

      describe 'reports class method' do
        let(:item) { bt[1] }
        it { expect(item[:method]).to eq('Cls.#class_method1') }
        it { expect(item[:count]).to eq(20) }
        it { expect(item[:backtrace].length).to be > 0 }
      end

      describe 'reports module method' do
        let(:item) { bt[2] }
        it { expect(item[:method]).to eq('Mod.#module_method1') }
        it { expect(item[:count]).to eq(10) }
        it { expect(item[:backtrace].length).to be > 0 }
      end
    end
  end
end
