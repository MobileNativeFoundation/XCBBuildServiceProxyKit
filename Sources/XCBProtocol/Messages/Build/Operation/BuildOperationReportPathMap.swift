public struct BuildOperationReportPathMap: Message {
    public static let name = "BUILD_OPERATION_REPORT_PATH_MAP"

    public var copiedPathMap: [String: String]
    public var generatedFilesPathMap: [String: String]
    
    public init(
        copiedPathMap: [String: String],
        generatedFilesPathMap: [String: String]
    ) {
        self.copiedPathMap = copiedPathMap
        self.generatedFilesPathMap = generatedFilesPathMap
    }
}
