public struct Workspace {
    public var guid: String
    public var name: String
    public var path: String // `Path`
    public var projectSignatures: [String]

    public init(
        guid: String,
        name: String,
        path: String,
        projectSignatures: [String]
    ) {
        self.guid = guid
        self.name = name
        self.path = path
        self.projectSignatures = projectSignatures
    }
}
