public struct CreateSessionResponse: SessionMessage {
    public static let name = "SESSION_CREATED"

    public var sessionHandle: String
    public var diagnostics: [Diagnostic]

    public init(sessionHandle: String, diagnostics: [Diagnostic]) {
        self.sessionHandle = sessionHandle
        self.diagnostics = diagnostics
    }
}
