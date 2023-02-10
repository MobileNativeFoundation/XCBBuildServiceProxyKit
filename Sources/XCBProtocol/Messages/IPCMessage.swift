public struct IPCMessage<Message: XCBProtocol.Message> {
    // TODO: public static let? messageNameToID: [String: Message.Type]
    // TODO: allow custom mapping, but allowing custom `messageTypes`

    public let message: Message

    public init(message: Message) {
        self.message = message
    }
}

extension IPCMessage: Encodable where Message: Encodable {
    public enum CodingKeys: String, CodingKey {
        case name
        case message
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(Message.name, forKey: .name)
        try container.encode(message, forKey: .message)
    }
}
