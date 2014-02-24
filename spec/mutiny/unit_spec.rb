require "mutiny/unit"

module Mutiny
  describe Unit do
    it "can determine class name from code" do
      unit = Unit.new(code: "class Min; end")
      
      expect(unit.class_name).to eq("Min")
    end
  end
end
