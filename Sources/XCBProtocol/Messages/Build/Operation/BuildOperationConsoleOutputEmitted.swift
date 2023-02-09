public struct BuildOperationConsoleOutputEmitted: Message {
    public static let name = "BUILD_CONSOLE_OUTPUT_EMITTED"

    public var data: [UInt8]
    public var taskID: Int?
    public var targetID: Int?
    
    public init(data: [UInt8], taskID: Int?, targetID: Int?) {
        self.data = data
        self.taskID = taskID
        self.targetID = targetID
    }
}
