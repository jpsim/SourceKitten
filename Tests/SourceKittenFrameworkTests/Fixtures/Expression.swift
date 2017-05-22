class Hidden {}

class HiddenUsage {
    func functionWithHiddenDependency() {
        let hidden = Hidden()
        print("\(hidden)")
    }
}