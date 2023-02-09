public struct IncrementalPIFLookupFailureRequest: SessionMessage {
    public static let name = "INCREMENTAL_PIF_LOOKUP_FAILURE"

    public var sessionHandle: String
    public var diagnostic: String

    public init(sessionHandle: String, diagnostic: String) {
        self.sessionHandle = sessionHandle
        self.diagnostic = diagnostic
    }
}
