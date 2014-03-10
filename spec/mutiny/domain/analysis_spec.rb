require "mutiny/domain/analysis"

module Mutiny
  describe Analysis do
    before(:each) do
      @m1, @m2, @m3 = Object.new, Object.new, Object.new
      @m1r1, @m1r2, @m2r1 = Object.new, Object.new, Object.new
      
      subject.record_dead(@m1, [@m1r1, @m1r2])
      subject.record_dead(@m2, [@m2r1])
      subject.record_alive(@m3, [])
    end
    
    it "collects mutants" do
      expect(subject.mutants).to eq([@m1, @m2, @m3])
    end
    
    it "collects results" do
      expect(subject.results).to eq([@m1r1, @m1r2, @m2r1])
    end
    
    it "counts the number of mutants recorded" do
      expect(subject.length).to eq(3)
    end
    
    it "counts the number of killed mutants" do
      expect(subject.kill_count).to eq(2)
    end
    
    it "calculates score" do
      expect(subject.score).to eq(2.0 / 3.0)
    end
  end
end
