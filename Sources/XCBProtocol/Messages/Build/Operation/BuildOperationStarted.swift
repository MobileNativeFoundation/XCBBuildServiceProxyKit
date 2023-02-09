public struct BuildOperationStarted: Message {
    public static let name = "BUILD_OPERATION_STARTED"

    public var id: Int
    
    public init(id: Int) {
        self.id = id
    }
}
