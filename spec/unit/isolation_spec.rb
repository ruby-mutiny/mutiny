require "mutiny/isolation"

module Mutiny
  # This code originally based on Markus Schirp's implementation of Mutant::Isolation::Fork
  #  https://github.com/mbj/mutant/blob/master/spec/unit/mutant/isolation_spec.rb
  describe Isolation do
    subject { described_class }

    before do
      @initial = 1
    end

    describe '.run' do
      it 'does isolate side effects' do
        subject.call { @initial = 2  }
        expect(@initial).to be(1)
      end

      it 'return block value' do
        expect(subject.call { :foo }).to be(:foo)
      end

      it 'wraps exceptions' do
        expect { subject.call { fail } }.to raise_error(Isolation::Error, 'marshal data too short')
      end

      xit 'wraps exceptions caused by crashing ruby' do
        expect do
          subject.call { fail RbBug.call }
        end.to raise_error(Isolation::Error)
      end

      it 'redirects $stderr of children to /dev/null' do
        begin
          Tempfile.open('mutiny-test') do |file|
            $stderr = file
            subject.call { $stderr.puts('test') }
            file.rewind
            expect(file.read).to eql('')
          end
        ensure
          $stderr = STDERR
        end
      end
    end
  end
end
