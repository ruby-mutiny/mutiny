require "mutiny/results"

module Mutiny
  describe Results do
    it "distinguishes between mutants with different lines and changes" do
      mutants = [
        FakeMutant2.new(4, :<, :killed),
        FakeMutant2.new(5, :<, :alive),
        FakeMutant2.new(5, :>, :unknown)
      ]
      
      mutants.each { |m| subject.add(m) }
      
      expect(subject.for(4, :<)).to eq(mutants[0])
      expect(subject.for(5, :<)).to eq(mutants[1])
      expect(subject.for(5, :>)).to eq(mutants[2])
    end
    
    it "counts the number of mutants recorded" do
      subject.add(FakeMutant2.new(4, :<, :killed))
      subject.add(FakeMutant2.new(5, :<, :alive))
      subject.add(FakeMutant2.new(5, :>, :unknown))
      
      expect(subject.length).to eq(3)
    end
    
    it "counts the number of killed mutants" do
      subject.add(FakeMutant2.new(4, :<, :killed))
      subject.add(FakeMutant2.new(5, :<, :alive))
      subject.add(FakeMutant2.new(5, :>, :unknown))
      
      expect(subject.kill_count).to eq(1)
    end
    
    it "calculates score" do
      subject.add(FakeMutant2.new(4, :<, :killed))
      subject.add(FakeMutant2.new(5, :<, :killed))
      subject.add(FakeMutant2.new(6, :<, :alive))
      
      expect(subject.score).to eq(2.0 / 3.0)
    end
    
    class FakeMutant2 < Struct.new(:line, :change, :status)
      def alive?
        status == :alive
      end
      
      def killed?
        status == :killed
      end
    end
  end
end