# Release History

## v0.2.7 (22 February 2016)
* Fix bug whereby analysis was incorrectly reusing test results for all previous mutants when evaluating current mutant.

## v0.2.6 (17 February 2016)
* A mutant's position now carries information about the affected range in the subject, as well as in the mutated code.

## v0.2.5 (16 February 2016)
* Fix bug in the --cached switch of the score command, which was preventing mutants being correctly loaded from disk on Linux.
* Fix bug in the --cached switch of the score command, which was causing mutiny to report the incorrect path to subject files.
* Improve extensibility by supporting different implementations of the analyser. This has removed the need to have test selection as an extension point (for now).

## v0.2.4 (10 February 2016)
* Add --cached switch to the score command, which loads mutants from disk rather than generating them anew.
* Various changes to improve extensibility (i.e., mutant storage, test selection) and capabilities (i.e., mutant location and test hooks).

## v0.2.3 (26 January 2016)
* Add mutation name to each mutant written to disk
* Update to Ruby 2.2.3

## v0.2.2 (20 January 2016)
* Add rudimentary support for stillborn mutants
* Better error reporting during mutant generation
* Reduce chance that irrelevant subjects are selected for mutation

## v0.2.1 (20 August 2015)
* Fix [#1](https://github.com/mutiny/mutiny/issues/1) - "Uninitialized constant" exception for all commands

## v0.2.0 (14 August 2015)
* Implement `mutiny score` mode which performs mutation analysis

## v0.1.0 (5 June 2015)
Provide support for:
* Running mutation testing commands via the `mutiny` binary
* Checking that a program is amenable to mutation testing
* Generating mutants using traditional method-level operators
* Integration with RSpec 3
