public struct BuildCreated: Message {
    public static let name = "BUILD_CREATED"

    public var id: Int
    
    public init(id: Int) {
        self.id = id
    }
}
