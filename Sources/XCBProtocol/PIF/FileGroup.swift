public class FileGroup {
    public var name: String
    public var children: [GroupTreeReference]

    public init(name: String, children: [GroupTreeReference]) {
        self.name = name
        self.children = children
    }
}
