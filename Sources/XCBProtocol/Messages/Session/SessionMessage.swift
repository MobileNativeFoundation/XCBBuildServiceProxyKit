public protocol SessionMessage: Message {
    var sessionHandle: String { get }
}
