//
//  Clang+SourceKitten.swift
//  SourceKitten
//
//  Created by Thomas Goyne on 9/17/15.
//  Copyright © 2015 SourceKitten. All rights reserved.
//

#if SWIFT_PACKAGE
import Clang_C
#endif
import Foundation
import SWXMLHash

private var interfaceUUIDMap = [String: String]()

struct ClangIndex {
    private let cx = clang_createIndex(0, 1)

    func open(file file: String, args: [UnsafePointer<Int8>]) -> CXTranslationUnit {
        return clang_createTranslationUnitFromSourceFile(cx,
            file,
            Int32(args.count),
            args,
            0,
            nil)
    }
}

struct ClangAvailability {
    let alwaysDeprecated: Bool
    let alwaysUnavailable: Bool
    let deprecationMessage: String?
    let unavailableMessage: String?
}

extension CXString: CustomStringConvertible {
    func str() -> String? {
        return String.fromCString(clang_getCString(self))
    }

    public var description: String {
        return str() ?? "<null>"
    }
}

extension CXTranslationUnit {
    func cursor() -> CXCursor {
        return clang_getTranslationUnitCursor(self)
    }
}

extension CXCursor {
    func location() -> SourceLocation {
        return SourceLocation(clangLocation: clang_getCursorLocation(self))
    }

    func extent() -> (start: SourceLocation, end: SourceLocation) {
        let extent = clang_getCursorExtent(self)
        let start = SourceLocation(clangLocation: clang_getRangeStart(extent))
        let end = SourceLocation(clangLocation: clang_getRangeEnd(extent))
        return (start, end)
    }

    func shouldDocument() -> Bool {
        return clang_isDeclaration(kind) != 0 &&
            kind != CXCursor_ParmDecl &&
            kind != CXCursor_TemplateTypeParameter &&
            clang_Location_isInSystemHeader(clang_getCursorLocation(self)) == 0
    }

    func declaration() -> String? {
        let comment = parsedComment()
        if comment.kind() == CXComment_Null {
            return str()
        }
        let commentXML = clang_FullComment_getAsXML(comment).str() ?? ""
        guard let rootXML = SWXMLHash.parse(commentXML).children.first else {
            fatalError("couldn't parse XML")
        }
        return rootXML["Declaration"].element?.text?
            .stringByReplacingOccurrencesOfString("\n@end", withString: "")
            .stringByReplacingOccurrencesOfString("@property(", withString: "@property (")
    }

    func objCKind() -> ObjCDeclarationKind {
        return ObjCDeclarationKind.fromClang(kind)
    }

    func str() -> String? {
        let cursorExtent = extent()
        let contents = try! NSString(contentsOfFile: cursorExtent.start.file, encoding: NSUTF8StringEncoding)
        return contents.substringWithSourceRange(cursorExtent.start, end: cursorExtent.end)
    }

    func name() -> String {
        let spelling = clang_getCursorSpelling(self).str()!
        let type = objCKind()
        if let usrString = usr() where spelling.isEmpty && type == .Enum {
            // libClang considers enums declared like `typedef enum {} name;` rather than `NS_ENUM()`
            // to have a cursor spelling of "" (empty string). So we parse the USR to extract the actual name.
            let prefix = "c:@EA@"
            assert(usrString.hasPrefix(prefix))
            let index = usrString.startIndex.advancedBy(prefix.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
            return usrString.substringFromIndex(index)
        } else if let usrNSString = usr() as NSString? where type == .Category {
            let ext = (usrNSString.rangeOfString("c:objc(ext)").location == 0)
            let regex = try! NSRegularExpression(pattern: "(\\w+)@(\\w+)", options: [])
            let range = NSRange(location: 0, length: usrNSString.length)
            let matches = regex.matchesInString(usrNSString as String, options: [], range: range)
            if matches.count > 0 {
                let categoryOn = usrNSString.substringWithRange(matches[0].rangeAtIndex(1))
                let categoryName = ext ? "" : usrNSString.substringWithRange(matches[0].rangeAtIndex(2))
                return "\(categoryOn)(\(categoryName))"
            } else {
                fatalError("Couldn't get category name")
            }
        } else if type == .MethodInstance {
            return "-" + spelling
        } else if type == .MethodClass {
            return "+" + spelling
        }
        return spelling
    }

    func usr() -> String? {
        return clang_getCursorUSR(self).str()
    }

    func platformAvailability() -> ClangAvailability {
        var alwaysDeprecated: Int32 = 0
        var alwaysUnavailable: Int32 = 0
        var deprecationString = CXString()
        var unavailableString = CXString()

        clang_getCursorPlatformAvailability(self,
                                            &alwaysDeprecated,
                                            &deprecationString,
                                            &alwaysUnavailable,
                                            &unavailableString,
                                            nil,
                                            0)
        return ClangAvailability(alwaysDeprecated: alwaysDeprecated != 0,
                                 alwaysUnavailable: alwaysUnavailable != 0,
                                 deprecationMessage: deprecationString.description,
                                 unavailableMessage: unavailableString.description)
    }

    func visit(block: CXCursorVisitorBlock) {
        clang_visitChildrenWithBlock(self, block)
    }

    func parsedComment() -> CXComment {
        return clang_Cursor_getParsedComment(self)
    }

    func flatMap<T>(block: (CXCursor) -> T?) -> [T] {
        var ret = [T]()
        visit() { cursor, _ in
            if let val = block(cursor) {
                ret.append(val)
            }
            return CXChildVisit_Continue
        }
        return ret
    }

    func commentBody() -> String? {
        let rawComment = clang_Cursor_getRawCommentText(self).str()
        let replacements = [
            "@param ": "- parameter: ",
            "@return ": "- returns: ",
            "@warning ": "- warning: ",
            "@see ": "- see: ",
            "@note ": "- note: ",
        ]
        var commentBody = rawComment?.commentBody()
        for (original, replacement) in replacements {
            commentBody = commentBody?.stringByReplacingOccurrencesOfString(original, withString: replacement)
        }
        return commentBody
    }

    func swiftDeclaration(compilerArguments: [String]) -> String? {
        let file = location().file
        let swiftUUID: String
        if let uuid = interfaceUUIDMap[file] {
            swiftUUID = uuid
        } else {
            swiftUUID = NSUUID().UUIDString
            interfaceUUIDMap[file] = swiftUUID
            // Generate Swift interface, associating it with the UUID
            _ = Request.Interface(file: file, uuid: swiftUUID).send()
        }

        guard let usr = usr(),
            usrOffset = Request.FindUSR(file: swiftUUID, usr: usr).send()[SwiftDocKey.Offset.rawValue] as? Int64 else {
            return nil
        }

        let cursorInfo = Request.CursorInfo(file: swiftUUID, offset: usrOffset, arguments: compilerArguments).send()
        guard let docsXML = cursorInfo[SwiftDocKey.FullXMLDocs.rawValue] as? String,
            swiftDeclaration = SWXMLHash.parse(docsXML).children.first?["Declaration"].element?.text else {
                return nil
        }
        return swiftDeclaration
    }
}

extension CXComment {
    func paramName() -> String? {
        guard clang_Comment_getKind(self) == CXComment_ParamCommand else { return nil }
        return clang_ParamCommandComment_getParamName(self).str()
    }

    func paragraph() -> CXComment {
        return clang_BlockCommandComment_getParagraph(self)
    }

    func paragraphToString(kindString: String? = nil) -> [Text] {
        if kind() == CXComment_VerbatimLine {
            return [.Verbatim(clang_VerbatimLineComment_getText(self).str()!)]
        } else if kind() == CXComment_BlockCommand  {
            return (0..<count()).reduce([]) { returnValue, childIndex in
                return returnValue + self[childIndex].paragraphToString()
            }
        }

        guard kind() == CXComment_Paragraph else {
            print("not a paragraph: \(kind())")
            return []
        }

        let paragraphString = (0..<count()).reduce("") { paragraphString, childIndex in
            let child = self[childIndex]
            if let text = clang_TextComment_getText(child).str() {
                return paragraphString + (paragraphString != "" ? "\n" : "") + text
            } else if child.kind() == CXComment_InlineCommand {
                // @autoreleasepool etc. get parsed as commands when not in code blocks
                return paragraphString + "@" + child.commandName()!
            }
            fatalError("not text: \(child.kind())")
        }
        return [.Para(paragraphString.stringByRemovingCommonLeadingWhitespaceFromLines(), kindString)]
    }

    func kind() -> CXCommentKind {
        return clang_Comment_getKind(self)
    }

    func commandName() -> String? {
        return clang_BlockCommandComment_getCommandName(self).str()
    }

    func count() -> UInt32 {
        return clang_Comment_getNumChildren(self)
    }

    subscript(idx: UInt32) -> CXComment {
        return clang_Comment_getChild(self, idx)
    }
}
