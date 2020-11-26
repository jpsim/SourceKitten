#if !os(Linux)

import Clang_C

public struct Parameter {
    public let name: String
    public let discussion: [Text]

    init(comment: CXComment) {
        name = comment.paramName() ?? "<none>"
        discussion = comment.paragraph().paragraphToString()
    }
}

#endif
