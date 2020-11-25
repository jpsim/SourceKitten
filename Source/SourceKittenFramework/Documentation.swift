#if !os(Linux)

#if SWIFT_PACKAGE
import Clang_C
#endif

public struct Documentation {
    public let parameters: [Parameter]
    public let returnDiscussion: [Text]

    init(comment: CXComment) {
        let comments = (0..<comment.count()).map { comment[$0] }
        parameters = comments.filter {
            $0.kind() == CXComment_ParamCommand
        }.map(Parameter.init)
        returnDiscussion = comments.filter {
            $0.kind() == CXComment_BlockCommand && $0.commandName() == "return"
        }.flatMap {
            $0.paragraphToString()
        }
    }
}

#endif
