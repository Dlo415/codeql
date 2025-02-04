private import codeql.swift.generated.expr.AutoClosureExpr
private import codeql.swift.elements.stmt.ReturnStmt

class AutoClosureExpr extends Generated::AutoClosureExpr {
  /** Gets the implicit return statement generated by this autoclosure expression. */
  ReturnStmt getReturn() { result = unique( | | this.getBody().getAnElement()) }

  override string toString() { result = this.getBody().toString() }
}
