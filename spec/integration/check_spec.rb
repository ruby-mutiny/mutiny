describe "Using Mutiny to check whether mutation testing can be carried out" do
  it "should report success for a valid setup" do
    cd "calculator"
    run "bundle exec mutiny check"

    expected_output = "Checking...\n" \
                      "  At least one relevant test found (6 in total)\n" \
                      "  All relevant tests passed\n" \
                      "Looks good!\n"

    expect(all_output).to eq(expected_output)
  end

  it "should report failure when there are no relevant tests" do
    cd "untested_calculator"
    run "bundle exec mutiny -r calculator check"

    expected_output = "Checking...\n" \
                      "  No relevant tests found (for modules matching '*')\n" \
                      "Either your mutiny configuration is wrong, or you're missing some tests!\n"

    expect(all_output).to eq(expected_output)
  end

  it "should report warning when there are failing tests" do
    cd "buggy_calculator"
    run "bundle exec mutiny -r calculator check"

    expected_output = "Checking...\n" \
                      "  At least one relevant test found (3 in total)\n" \
                      "  Not all relevant tests passed\n" \
                      "Looks ok, but note that mutiny is most effective when all tests pass.\n"

    expect(all_output).to eq(expected_output)
  end
end
