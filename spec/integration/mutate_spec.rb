describe "Using Mutiny to generate mutants" do
  it "should report statistics of generated mutants" do
    cd "calculator"
    run "bundle exec mutiny mutate"

    expected_output = "Mutating...\n" \
                      "Generated 14 mutants:\n" \
                      "  * calculator/max.rb - 7 mutants\n" \
                      "  * calculator/min.rb - 7 mutants\n" \
                      "Check the '.mutants' directory to browse the generated mutants.\n"

    expect(all_output).to eq(expected_output)
  end

  it "should write mutants to the .mutants directory" do
    cd "calculator"
    run "bundle exec mutiny mutate"

    check_file_content(".mutants/calculator/min.0.rb", /if true/)
    check_file_content(".mutants/calculator/min.1.rb", /if false/)
    check_file_content(".mutants/calculator/min.2.rb", /if right <= left/)
    check_file_content(".mutants/calculator/min.3.rb", /if right == left/)
    check_file_content(".mutants/calculator/min.4.rb", /if right != left/)
    check_file_content(".mutants/calculator/min.5.rb", /if right >= left/)
    check_file_content(".mutants/calculator/min.6.rb", /if right > left/)

    check_file_content(".mutants/calculator/max.0.rb", /if true/)
    check_file_content(".mutants/calculator/max.1.rb", /if false/)
    check_file_content(".mutants/calculator/max.2.rb", /if right < left/)
    check_file_content(".mutants/calculator/max.3.rb", /if right <= left/)
    check_file_content(".mutants/calculator/max.4.rb", /if right == left/)
    check_file_content(".mutants/calculator/max.5.rb", /if right != left/)
    check_file_content(".mutants/calculator/max.6.rb", /if right >= left/)
  end

  it "should write mutation name to each mutant" do
    cd "calculator"
    run "bundle exec mutiny mutate"

    check_file_content(".mutants/calculator/min.0.rb", /# RelationalExpressionReplacement/)
    check_file_content(".mutants/calculator/min.1.rb", /# RelationalExpressionReplacement/)
    check_file_content(".mutants/calculator/min.2.rb", /# RelationalOperatorReplacement/)
    check_file_content(".mutants/calculator/min.3.rb", /# RelationalOperatorReplacement/)
    check_file_content(".mutants/calculator/min.4.rb", /# RelationalOperatorReplacement/)
    check_file_content(".mutants/calculator/min.5.rb", /# RelationalOperatorReplacement/)
    check_file_content(".mutants/calculator/min.6.rb", /# RelationalOperatorReplacement/)

    check_file_content(".mutants/calculator/max.0.rb", /# RelationalExpressionReplacement/)
    check_file_content(".mutants/calculator/max.1.rb", /# RelationalExpressionReplacement/)
    check_file_content(".mutants/calculator/max.2.rb", /# RelationalOperatorReplacement/)
    check_file_content(".mutants/calculator/max.3.rb", /# RelationalOperatorReplacement/)
    check_file_content(".mutants/calculator/max.4.rb", /# RelationalOperatorReplacement/)
    check_file_content(".mutants/calculator/max.5.rb", /# RelationalOperatorReplacement/)
    check_file_content(".mutants/calculator/max.6.rb", /# RelationalOperatorReplacement/)
  end
end
