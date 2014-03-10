# Mutiny [![Build Status](https://travis-ci.org/mutiny/mutiny.png?branch=master)](https://travis-ci.org/mutiny/mutiny) [![Code Climate](https://codeclimate.com/github/mutiny/mutiny.png)](https://codeclimate.com/github/mutiny/mutiny) [![Dependency Status](https://gemnasium.com/mutiny/mutiny.png)](https://gemnasium.com/mutiny/mutiny) [![Coverage Status](https://coveralls.io/repos/mutiny/mutiny/badge.png?branch=master)](https://coveralls.io/r/mutiny/mutiny?branch=master)

A tiny mutation testing framework.

#### Usage
* `git clone` this repo
* `bundle install`
* `./bin/mutiny ./examples/max.rb ./examples/max_tests.rb` Note that we currently assume that tests.rb is a line-separated set of predicates (expressions that evaluate to either true or false).

#### To do list
* Consume a "diff", compute new results for impacted files, and merge into previous round of results

    * Get incrementality.feature passing:
      * Next step to passing feature is to determine impacted files:

            g = Git.open(dir)
            head, previous = g.log[0], g.log[1]
            g.diff(head, previous).map(&:path)

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
    
    * Should Mutant be immutable? (Currently, mutable due to the kill method and due to the results and id methods).
    
    * Should IDs be handled differently? Currently calculated by the store and then the session updates the in-memory objects. However, ids seems to only be necessary for persisting to disk...
    
    * Tests for Session.
    
* Extend framework to explore Program Analyser and more sophisticated Test Case Provider components (see OmniGraffle diagram)
