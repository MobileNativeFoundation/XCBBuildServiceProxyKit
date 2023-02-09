public struct BuildOperationTaskUpToDate: Message {
    public static let name = "BUILD_TASK_UPTODATE"

    public var taskGUID: ByteString
    public var targetID: Int?
    public var parentID: Int?
}
