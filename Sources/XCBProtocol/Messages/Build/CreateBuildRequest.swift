// FIXME: JSON Encode
public struct CreateBuildRequest: SessionMessage, Codable {
    public static let name = "CREATE_BUILD"

    public var sessionHandle: String
    public var responseChannel: UInt64
    public var request: BuildRequestMessagePayload
    public var onlyCreateBuildDescription: Bool

    public init(
        sessionHandle: String,
        responseChannel: UInt64,
        request: BuildRequestMessagePayload,
        onlyCreateBuildDescription: Bool
    ) {
        self.sessionHandle = sessionHandle
        self.responseChannel = responseChannel
        self.request = request
        self.onlyCreateBuildDescription = onlyCreateBuildDescription
    }
}
