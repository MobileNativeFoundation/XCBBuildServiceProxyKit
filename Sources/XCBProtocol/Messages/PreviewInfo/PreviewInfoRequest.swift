// FIXME: JSON Encode
public struct PreviewInfoRequest: SessionMessage {
    public static let name = "PREVIEW_INFO_REQUESTED"

    public var sessionHandle: String
    public var responseChannel: UInt64
    public var request: BuildRequestMessagePayload
    public var targetID: String

    /// e.g. `"/Full/Path/To/Project/Source/File.swift"`
    public var sourceFile: String // `Path`

    /// e.g. `"__XCPREVIEW_THUNKSUFFIX__"`
    public var thunkVariantSuffix: String

    public init(
        sessionHandle: String,
        responseChannel: UInt64,
        request: BuildRequestMessagePayload,
        targetID: String,
        sourceFile: String,
        thunkVariantSuffix: String
    ) {
        self.sessionHandle = sessionHandle
        self.responseChannel = responseChannel
        self.request = request
        self.targetID = targetID
        self.sourceFile = sourceFile
        self.thunkVariantSuffix = thunkVariantSuffix
    }
}
