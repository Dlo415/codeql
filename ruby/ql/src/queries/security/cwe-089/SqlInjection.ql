/**
 * @name SQL query built from user-controlled sources
 * @description Building a SQL query from user-controlled sources is vulnerable to insertion of
 *              malicious SQL code by the user.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.8
 * @precision high
 * @id rb/sql-injection
 * @tags security
 *       external/cwe/cwe-089
 */

import codeql.ruby.AST
import codeql.ruby.Concepts
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.BarrierGuards
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.TaintTracking
import DataFlow::PathGraph

class SqlInjectionConfiguration extends TaintTracking::Configuration {
  SqlInjectionConfiguration() { this = "SQLInjectionConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof SqlExecution }

  override predicate isSanitizer(DataFlow::Node node) {
    node instanceof StringConstCompareBarrier or
    node instanceof StringConstArrayInclusionCallBarrier
  }
}

from SqlInjectionConfiguration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This SQL query depends on a $@.", source.getNode(),
  "user-provided value"
