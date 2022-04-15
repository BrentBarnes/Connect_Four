
require 'master'

describe Master do
  describe '#rematch' do
    subject(:master) { described_class.new }
    context 'when user types \'y\'' do
      it 'calls play function again' do
        allow(master).to receive(:gets).and_return('y')
        expect(master).to receive(:play).once
        master.rematch
      end
    end

    context 'when user types \'n\'' do
      it 'returns false' do
        allow(master).to receive(:gets).and_return('n')
        expect { master.rematch }.to output("Bye!\n").to_stdout
      end
    end

    context 'when user uses uppercase letter' do
      it 'returns true' do
        allow(master).to receive(:gets).and_return('Y')
        expect(master).to receive(:play).once
        master.rematch
      end
    end

    context 'when user gives invalid input' do
      it 'calls #rematch? again' do
        allow(master).to receive(:gets).and_return('5', 'idk', 'n')
        expect(master).to receive(:rematch).and_call_original.exactly(3).times
        master.rematch
      end
    end
  end
end