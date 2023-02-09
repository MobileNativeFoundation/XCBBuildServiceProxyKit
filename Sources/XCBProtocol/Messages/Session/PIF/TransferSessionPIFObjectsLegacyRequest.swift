public struct TransferSessionPIFObjectsLegacyRequest: SessionMessage {
    public static let name = "TRANSFER_SESSION_PIF_OBJECTS_LEGACY_REQUEST"

    public var sessionHandle: String
    public var objects: [[UInt8]]

    public init(sessionHandle: String, objects: [[UInt8]]) {
        self.sessionHandle = sessionHandle
        self.objects = objects
    }
}
