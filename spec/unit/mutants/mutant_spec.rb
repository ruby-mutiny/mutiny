module Mutiny
  module Mutants
    describe Mutant do
      subject(:mutant) { Mutant.new(code: "class Hello; def run; 'Goodbye'; end; end") }

      it "overrides existing code when applied" do
        expect { mutant.apply }.to change { Hello.new.run }.from("Hello").to("Goodbye")
      end
    end
  end
end

class Hello
  def run
    "Hello"
  end
end
