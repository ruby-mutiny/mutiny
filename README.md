# Mutiny [![Build Status](https://travis-ci.org/mutiny/mutiny.svg?branch=master)](https://travis-ci.org/mutiny/mutiny) [![Code Climate](https://codeclimate.com/github/mutiny/mutiny/badges/gpa.svg)](https://codeclimate.com/github/mutiny/mutiny) [![Dependency Status](https://gemnasium.com/mutiny/mutiny.svg)](https://gemnasium.com/mutiny/mutiny) [![Test Coverage](https://codeclimate.com/github/mutiny/mutiny/badges/coverage.svg)](https://codeclimate.com/github/mutiny/mutiny)

A tiny mutation testing framework for Ruby. Used for exploring research ideas. For more stable and complete mutation testing in Ruby, use [mutant](https://github.com/mbj/mutant).

Currently supports Ruby versions of these [method level mutation operators](http://cs.gmu.edu/~offutt/mujava/mutopsMethod.pdf).

#### Usage
* `git clone` this repo
* `bundle install`
* `./bin/mutiny ./examples/max.rb ./examples/max_tests.rb` Note that we currently assume that tests.rb is a line-separated set of predicates (expressions that evaluate to either true or false).
