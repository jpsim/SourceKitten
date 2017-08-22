import Foundation
import SourceKittenFramework

func requestsFromLog(_ file: String) -> [NSDictionary] {
    let log = try! String(contentsOfFile: file, encoding: .utf8)
    let scanner = Scanner(string: log)
    var requests = [NSDictionary]()
    while scanner.scanUpTo("SourceKit-client: [2:request:", into: nil) {
        scanner.scanUpTo("{\n", into: nil)
        var rawNSRequest: NSString?
        scanner.scanUpTo("\n2017", into: &rawNSRequest)
        guard let rawRequest = rawNSRequest?.bridge() else { continue }
        var jsonInProgress = rawRequest
        do {
            let regex = try! NSRegularExpression(pattern: "(\\n +)(key\\.[\\w\\.-]+):", options: [])
            let range = NSRange(location: 0, length: jsonInProgress.bridge().length)
            jsonInProgress = regex.stringByReplacingMatches(in: jsonInProgress, options: [],
                                                            range: range,
                                                            withTemplate: "$1\"$2\":")
        }
        do {
            let regex = try! NSRegularExpression(pattern: "\": (source\\.[\\w\\.-]+)", options: [])
            let range = NSRange(location: 0, length: jsonInProgress.bridge().length)
            jsonInProgress = regex.stringByReplacingMatches(in: jsonInProgress, options: [],
                                                            range: range,
                                                            withTemplate: "\": \"$1\"")
        }
        let jsonString = jsonInProgress
        guard let jsonData = jsonString.data(using: .utf8) else {
            fatalError("Couldn't convert JSON string to Data")
        }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
            let jsonDictionary = jsonObject as? NSDictionary else {
            fatalError("Couldn't convert JSON data to object")
        }
        requests.append(jsonDictionary)
    }
    return requests
}

let unsupportedRequests = [
    "source.request.register-toolchains",
    "source.request.indexer.open-or-create",
    "source.request.indexer.close",
    "source.request.indexer.register-file",
    "source.request.indexer.unregister-file",
    "source.request.indexer.register-obj",
    "source.request.indexer.unregister-obj",
    "source.request.indexer.set-throttle-factor",
    "source.request.indexer.will-register-more-files",
    "source.request.indexer.is-quiescent",
    "source.request.indexer.dump-index-data",
    "source.request.indexer.srv.jump-to-expression-definition",
    "source.request.indexer.srv.jump-to-imported-file",
    "source.request.indexer.srv.jump-to-module-import-headers",
    "source.request.indexer.srv.code-completions-at-location",
    "source.request.indexer.srv.symbol-contains",
    "source.request.indexer.srv.file-contains",
    "source.request.indexer.srv.test-methods-structure",
    "source.request.indexer.srv.main-files-for-file",
    "source.request.indexer.srv.build-settings-for-file",
    "source.request.indexer.prebuild-completed",
    "source.request.indexer.notify-indexable-did-add-file",
    "source.request.indexer.notify-indexable-will-remove-file",
    "source.request.indexer.notify-indexable-did-rename-file",
    "source.request.indexer.build-settings-changed",
    "source.request.indexer.build-operation-will-start",
    "source.request.indexer.build-operation-did-stop",
    "source.request.indexer.editor-will-save-file",
    "source.request.document.imported-files",
    "source.request.workspace.callers-for-symbol",
    "source.request.workspace.symbol-declarations",
    "source.request.workspace.symbol-definitions",
    "source.request.workspace.symbol-occurrences",
    "source.request.workspace.symbol-references",
    "source.request.workspace.symbol-subclasses",
    "source.request.workspace.symbol-superclasses",
    "source.request.workspace.symbol-categories",
    "source.request.workspace.symbol-interfaces",
    "source.request.workspace.symbol-protocols",
    "source.request.workspace.symbol-all-protocols",
    "source.request.workspace.symbol-all-superclasses",
    "source.request.workspace.symbol-all-subclasses",
    "source.request.workspace.symbol-implementing-classes-for-protocol",
    "source.request.workspace.symbol-all-occurrences-of-members",
    "source.request.workspace.symbol-referencing-files",
    "source.request.workspace.symbol-model-occurrence",
    "source.request.workspace.symbol-container",
    "source.request.workspace.symbol-containers",
    "source.request.workspace.symbol-overridden-symbols",
    "source.request.workspace.symbol-property",
    "source.request.workspace.symbol-related-class",
    "source.request.workspace.symbol-ib-relation-class",
    "source.request.workspace.symbol-members-matching-kind",
    "source.request.workspace.all-symbols-matching-name",
    "source.request.workspace.all-classes-matching-name",
    "source.request.workspace.all-symbols-matching-kind",
    "source.request.workspace.count-of-symbols-matching-kind",
    "source.request.workspace.all-parents-of-symbols",
    "source.request.workspace.symbols-for-resolutions",
    "source.request.workspace.files-including-file",
    "source.request.workspace.files-included-by-file",
    "source.request.workspace.members-matching-kinds",
    "source.request.workspace.genius-referencing-test-classes",
    "source.request.document.symbols-matching-name",
    "source.request.document.genius-callers-callees",
    "source.request.document.parsed-code-comment"
]

for request in requestsFromLog(CommandLine.arguments[1]) {
    if unsupportedRequests.contains(request["key.request"] as! String) {
        continue
    }
    guard let sk = toSourceKitRepresentable(request) else {
        fatalError("couldn't convert to SourceKitRepresentable")
    }
    print(toJSON(Request.customRequest(request: toSourceKit(sk)).send()))
    RunLoop.current.run(until: Date().addingTimeInterval(1))
}
