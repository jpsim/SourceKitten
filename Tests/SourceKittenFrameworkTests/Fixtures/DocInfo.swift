
/// Single line commented function
func singleLineCommentedFunc() {
}

/**
  Multiple line
  commented function.
 */
func multiLineCommentedFunc() {
}

func undocumentedFunc() {
}

// This comment is not a docstring.
func nonDocCommentDocumentedFunc() {
}

/* This comment is also not a docstring.
   but covers multiple lines.
*/   
func nonDocCommentMultiLineDocumentedFunc() {
}


/// A documented struct
struct DocumentedStruct {
  /// A documented variable.
  let x: String

  /**
   * A documented member func.
   */
  fileprivate func documentedMemberFunc() {
  }
}

/// A doc string that refers to nothing.

