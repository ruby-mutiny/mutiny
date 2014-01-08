require_relative "../lib/max"

describe Max do
  it "test1" do
    expect(Max.new.run(4, 4)).to eq(4)
  end
  it "test2" do
    expect(Max.new.run(4, 3)).to eq(4)
  end
  it "test3" do
    expect(Max.new.run(3, 4)).to eq(4)
  end
end