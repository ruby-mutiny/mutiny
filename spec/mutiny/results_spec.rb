require "mutiny/results"

module Mutiny
  describe Results do
    it "stores a result" do
      subject.record(FakeMutant.new(4, :<), :killed)
      
      expect(subject.for(4, :<)).to eq(:killed) 
    end
    
    it "distinguishes between mutants with different lines and changes" do
      subject.record(FakeMutant.new(4, :<), :killed)
      subject.record(FakeMutant.new(5, :<), :alive)
      subject.record(FakeMutant.new(5, :>), :unknown)
      
      expect(subject.for(4, :<)).to eq(:killed)
      expect(subject.for(5, :<)).to eq(:alive)
      expect(subject.for(5, :>)).to eq(:unknown)
    end
    
    it "counts the number of mutants recorded" do
      subject.record(FakeMutant.new(4, :<), :killed)
      subject.record(FakeMutant.new(5, :<), :alive)
      subject.record(FakeMutant.new(5, :>), :unknown)
      
      expect(subject.length).to eq(3)
    end
    
    it "counts the number of killed mutants" do
      subject.record(FakeMutant.new(4, :<), :killed)
      subject.record(FakeMutant.new(5, :<), :alive)
      subject.record(FakeMutant.new(5, :>), :unknown)
      
      expect(subject.kill_count).to eq(1)
    end
    
    it "calculates score" do
      subject.record(FakeMutant.new(4, :<), :killed)
      subject.record(FakeMutant.new(5, :<), :killed)
      subject.record(FakeMutant.new(6, :<), :alive)
      
      expect(subject.score).to eq(2.0 / 3.0)
    end
    
    class FakeMutant < Struct.new(:line, :change); end
  end
end
