public struct BuildOperationTargetUpToDate: Message {
    public static let name = "BUILD_TARGET_UPTODATE"

    public var guid: String
    
    public init(guid: String) {
        self.guid = guid
    }
}
