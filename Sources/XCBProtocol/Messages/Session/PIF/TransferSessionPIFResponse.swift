public struct TransferSessionPIFResponse: Message {
    public static let name = "TRANSFER_SESSION_PIF_RESPONSE"

    public var missingObjects: [MissingObject]

    public init(missingObjects: [MissingObject]) {
        self.missingObjects = missingObjects
    }

    public enum PIFObjectType {
        case workspace
        case project
        case target
    }

    public struct MissingObject {
        public var type: PIFObjectType
        public var signature: String
    }
}
