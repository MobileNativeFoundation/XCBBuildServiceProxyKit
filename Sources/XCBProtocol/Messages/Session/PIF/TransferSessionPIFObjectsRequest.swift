public struct TransferSessionPIFObjectsRequest: SessionMessage {
    public static let name = "TRANSFER_SESSION_PIF_OBJECTS_REQUEST"

    public var sessionHandle: String
    public var objects: [ObjectData]

    public init(sessionHandle: String, objects: [ObjectData]) {
        self.sessionHandle = sessionHandle
        self.objects = objects
    }

    public struct ObjectData {
        public var typeName: String
        public var signature: String
        public var data: ByteString
    }
}
