public struct BuildOperationTargetEnded: Message {
    public static let name = "BUILD_TARGET_ENDED"

    public var id: Int
    
    public init(id: Int) {
        self.id = id
    }
}
