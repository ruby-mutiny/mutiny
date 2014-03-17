# Mutiny [![Build Status](https://travis-ci.org/mutiny/mutiny.png?branch=master)](https://travis-ci.org/mutiny/mutiny) [![Code Climate](https://codeclimate.com/github/mutiny/mutiny.png)](https://codeclimate.com/github/mutiny/mutiny) [![Dependency Status](https://gemnasium.com/mutiny/mutiny.png)](https://gemnasium.com/mutiny/mutiny) [![Coverage Status](https://coveralls.io/repos/mutiny/mutiny/badge.png?branch=master)](https://coveralls.io/r/mutiny/mutiny?branch=master)

A tiny mutation testing framework.

#### Usage
* `git clone` this repo
* `bundle install`
* `./bin/mutiny ./examples/max.rb ./examples/max_tests.rb` Note that we currently assume that tests.rb is a line-separated set of predicates (expressions that evaluate to either true or false).

#### To do list

* Prepare for first round of experiments
  * Implement some more mutation operators
      * [Method level mutations](http://cs.gmu.edu/~offutt/mujava/mutopsMethod.pdf)
          * UAOD -- delete unary arithmetic operator (-)
          * UAOI -- insert unary arithmetic operator (-)
          * COD -- Delete unary conditional ops (!)
          * COI -- Insert unary conditional ops (!)
          * LOI -- Insert unary logic ops (~)
          * LOD -- Delete unary logic ops (~)
      * Investigate whether it makes sense to separate mutation creating component from mutation analysis component
          * Refactor mutation operators to extract common logic
          * Consider refactoring AST match and pattern classes, and extracting as a separate gem
          * Additional mutator.feature that tests a sensible error is reported when an unknown mutation operator is configured
          * Additional mutator.feature that tests that >1 mutant can be seeded on a single line
  
  * Identify candidate projects
      * Must use RSpec
      * Must not have any external dependencies?
    
  * Investigate the time savings of using incremental mode over the course of the project's history
      * As well as comparing time taken, need to compare the results of incremental and non-incremental modes to ensure that incremental mode is producing accurate results.
      * Might need to enhance the change detector to be able to identify dependencies of units. For example, if `max_spec` tests `max` and `max` uses `calculator`, `max_spec` is dependent on calculator. If `calculator` changes, `max_spec` should be detected as impacted.

* More fine-grained change detection. Some ideas:
  * When an example is removed from a spec, we should be able to quickly recompute the mutation score. To allow this, we would need to store the results of each example for each mutant. We then remove the results for the deleted example, and recalculate the mutation score without running any tests.
  
  * When a change to a unit is equivalent to swapping the unit for a previously analysed mutant of that unit, we should be able to quickly recompute the mutation score. We simply swap the mutant and unit in the results, and recalculate whether mutants are alive or dead (the new unit might cause different mutants to die). Again, to allow this we would need to store the results of each example for each mutant.
  
  * When a change to a unit is localised to a single line / method / subset of the file (i.e., a fragment), we only need to recalculate the mutants for that fragment. (However, I suspect we will often need to re-test the mutants and source file to obtain an accurate mutation score: i.e., unlike the points above, this speed up only impacts mutant creation and not mutant analysis) To allow this, the mutation creation component should be able to locate mutation sites in a specific fragment of a file. 
  
* Housekeeping

  * Consider refactoring mutant.rb so that it does not contain a code attribute (perhaps instead it should compute code by passing the file and line number to its operator?)

  * Tests for Session.
    
* Extend framework to explore Program Analyser and more sophisticated Test Case Provider components (see OmniGraffle diagram)
