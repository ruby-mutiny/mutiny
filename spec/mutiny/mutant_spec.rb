require "mutiny/mutant"

module Mutiny
  describe Mutant do
    it "is alive initially" do
      expect(subject.alive?).to be_true
      expect(subject.killed?).to be_false
    end
    
    it "can be killed" do
      subject.kill
      
      expect(subject.killed?).to be_true
      expect(subject.alive?).to be_false
    end
  end
end
