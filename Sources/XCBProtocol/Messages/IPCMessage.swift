public struct IPCMessage {
    // TODO: public static let? messageNameToID: [String: Message.Type]
    // TODO: allow custom mapping, but allowing custom `messageTypes`

    public let message: Message

    public init(message: Message) {
        self.message = message
    }
}
