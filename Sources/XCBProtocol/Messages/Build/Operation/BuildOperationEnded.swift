public struct BuildOperationEnded: Message {
    public static let name = "BUILD_OPERATION_ENDED"

    public var id: Int
    public var status: Status
    
    public init(id: Int, status: Status) {
        self.id = id
        self.status = status
    }

    public enum Status {
        case succeeded
        case cancelled
        case failed
    }
}
