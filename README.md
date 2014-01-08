# Mutiny [![Build Status](https://travis-ci.org/louismrose/mutiny.png?branch=master)](https://travis-ci.org/louismrose/mutiny) [![Code Climate](https://codeclimate.com/github/louismrose/mutiny.png)](https://codeclimate.com/github/louismrose/mutiny) [![Dependency Status](https://gemnasium.com/louismrose/mutiny.png)](https://gemnasium.com/louismrose/mutiny) [![Coverage Status](https://coveralls.io/repos/louismrose/mutiny/badge.png?branch=master)](https://coveralls.io/r/louismrose/mutiny?branch=master)

A tiny mutation testing framework.

#### Usage
* `git clone` this repo
* `bundle install`
* `./bin/mutiny ./examples/max.rb ./examples/max_tests.rb` Note that we currently assume that tests.rb is a line-separated set of predicates (expressions that evaluate to either true or false).

#### To do list
* Extend framework to run tests using the RSpec
* Extend framework to explore Program Analyser and more sophisticated Test Case Provider components (see OmniGraffle diagram)
