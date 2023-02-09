public struct BuildOperationProgressUpdated: Message {
    public static let name = "BUILD_PROGRESS_UPDATED"

    public var targetName: String?
    public var statusMessage: String
    public var percentComplete: Double
    public var showInLog: Bool
    
    public init(
        targetName: String?,
        statusMessage: String,
        percentComplete: Double,
        showInLog: Bool
    ) {
        self.targetName = targetName
        self.statusMessage = statusMessage
        self.percentComplete = percentComplete
        self.showInLog = showInLog
    }
}
