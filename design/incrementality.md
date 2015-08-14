## Incrementality

* Experimentation to validate approach
  * Write scripting
      * Incremental: Should generate mutant delta (new / deleted mutants) between two git commits. Creating new mutants should be possible from existing change detector. Deleting obsoleted mutants will likely require enhancements to the change detector.
      * Experimental harness: should run non-incremental mode for each commit, and compare to results of incremental mode. Store data for paper and print a summary that shows the number of mutants evaluated by incremental and non-incremental mode.

  * Candidate projects
      * Thor: https://github.com/erikhuda/thor
      * Rake (ruled out as it uses minitest rather than RSpec)
      * Rack (ruled out as it uses Bacon rather than RSpec)
      * ActiveSupport and other Rails subgems (ruled out as it uses minitest rather than RSpec)

  * Experiments
      * Compare incremental and non-incremental mutator (seeding of faults) to determine typical magnitude of change over a project. What kind of granularity do we need to make a significant difference (file < method < ast nodes)?
      * Compare incremental and non-incremental analyser to determine typical impact of change on mutation testing. Analyser will first need to be enhanced with an incremental model that determines which of a set of existing mutants need to be reevaluated.

  * Overall aim: investigate the time savings of using incremental mode over the course of the project's history
      * Measurements
          * Could compare time taken for mutation testing each commit.
          * Alternatively, could compare the number of mutants that need to be re-evaluated. This would allow experimentation to proceed without actually executing any tests; just creating mutants and marking those which need to be re-evaluated. The incremental mode should count any new mutants, mark any mutants from the previous round that need to be re-evaluated, (and mark any mutants from the previous round that need to be deleted?).
      * Validity of results:
          * Whatever is measured, I need to compare the _results_ of incremental and non-incremental modes to ensure that incremental mode is correct.
          * Might need to enhance the change detector to be able to identify dependencies of units. For example, if `max_spec` tests `max` and `max` uses `calculator`, `max_spec` is dependent on calculator. If `calculator` changes, `max_spec` should be detected as impacted.


* More fine-grained change detection. Some ideas:
  * When an example is removed from a spec, we should be able to quickly recompute the mutation score. To allow this, we would need to store the results of each example for each mutant. We then remove the results for the deleted example, and recalculate the mutation score without running any tests.

  * When a change to a unit is equivalent to swapping the unit for a previously analysed mutant of that unit, we should be able to quickly recompute the mutation score. We simply swap the mutant and unit in the results, and recalculate whether mutants are alive or dead (the new unit might cause different mutants to die). Again, to allow this we would need to store the results of each example for each mutant.

  * When a change to a unit is localised to a single line / method / subset of the file (i.e., a fragment), we only need to recalculate the mutants for that fragment. (However, I suspect we will often need to re-test the mutants and source file to obtain an accurate mutation score: i.e., unlike the points above, this speed up only impacts mutant creation and not mutant analysis) To allow this, the mutation creation component should be able to locate mutation sites in a specific fragment of a file.
