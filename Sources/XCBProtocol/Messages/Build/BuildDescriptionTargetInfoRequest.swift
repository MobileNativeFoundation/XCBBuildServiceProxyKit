public struct BuildDescriptionTargetInfoRequest: SessionMessage {
    public static let name = "BUILD_DESCRIPTION_TARGET_INFO"

    public var sessionHandle: String
    public var responseChannel: UInt64
    public var request: BuildRequestMessagePayload

    public init(
        sessionHandle: String, 
        responseChannel: UInt64, 
        request: BuildRequestMessagePayload)
    {
        self.sessionHandle = sessionHandle
        self.responseChannel = responseChannel
        self.request = request
    }
}
