# Mutiny [![Build Status](https://travis-ci.org/mutiny/mutiny.png?branch=master)](https://travis-ci.org/mutiny/mutiny) [![Code Climate](https://codeclimate.com/github/mutiny/mutiny.png)](https://codeclimate.com/github/mutiny/mutiny) [![Dependency Status](https://gemnasium.com/mutiny/mutiny.png)](https://gemnasium.com/mutiny/mutiny) [![Coverage Status](https://coveralls.io/repos/mutiny/mutiny/badge.png?branch=master)](https://coveralls.io/r/mutiny/mutiny?branch=master)

A tiny mutation testing framework.

#### Usage
* `git clone` this repo
* `bundle install`
* `./bin/mutiny ./examples/max.rb ./examples/max_tests.rb` Note that we currently assume that tests.rb is a line-separated set of predicates (expressions that evaluate to either true or false).

#### To do list
* Consume a "diff", compute new results for impacted files, and merge into previous round of results

    * Get incrementality.feature passing:
      * Current idea: Can the change detector be a separate component? The results of which can then be used to configure mutiny so that it only analyses those units which have changed. Given a folder "spec" this new component would return the list of specs that need to be analysed. (Eventually, this component would be given a set of units and possibly a set of existing mutants and would return a new set of mutants that need to be analysed. The new set of mutants is likely to be a subset of the existing mutants, but might also contain some new mutants).
    
      * Look into autoloading (etc.) in Ruby. Must be a better way than a bunch of requires at start of files like command\_line?

    * Need a way of loading existing results from disk to determine which results need to be recalculated. Schema:

            Mutants
            id | source_file | line | operator       | operator_state | status
            00 | lib/calc.rb |      |                |                | killed
            01 | lib/calc.rb | 4    | BinaryOperator | >              | alive
            
            Examples
            id | spec_file        | name
            12 | lib/calc_spec.rb | adds
            
            Results
            mutant | example | status
            00     | 12      | passed
            01     | 12      | failed

    * Consider refactoring mutant.rb so that it does not contain a code attribute (perhaps instead it should compute code by passing the file and line number to its operator?)
    
    * Tests for Session.
    
* Extend framework to explore Program Analyser and more sophisticated Test Case Provider components (see OmniGraffle diagram)
