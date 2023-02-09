public struct SetSessionSystemInfoRequest: SessionMessage {
    public static let name = "SET_SESSION_SYSTEM_INFO"

    public var sessionHandle: String
    public var operatingSystemVersion: Version
    public var productBuildVersion: String
    public var nativeArchitecture: String

    public init(
        sessionHandle: String,
        operatingSystemVersion: Version,
        productBuildVersion: String,
        nativeArchitecture: String
    ) {
        self.sessionHandle = sessionHandle
        self.operatingSystemVersion = operatingSystemVersion
        self.productBuildVersion = productBuildVersion
        self.nativeArchitecture = nativeArchitecture
    }
}
