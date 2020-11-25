import Commandant
import SourceKittenFramework

struct VersionCommand: CommandProtocol {
    let verb = "version"
    let function = "Display the current version of SourceKitten"

    func run(_ options: NoOptions<SourceKittenError>) -> Result<(), SourceKittenError> {
        print(Version.current.value)
        return .success(())
    }
}
