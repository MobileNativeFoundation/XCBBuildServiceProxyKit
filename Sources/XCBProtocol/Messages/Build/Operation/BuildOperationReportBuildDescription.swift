public struct BuildOperationReportBuildDescription: Message {
    public static let name = "BUILD_OPERATION_REPORT_BUILD_DESCRIPTION_ID"

    public var buildDescriptionID: String

    public init(buildDescriptionID: String) {
        self.buildDescriptionID = buildDescriptionID
    }
}
