public struct StringResponse: Message {
    public static let name = "STRING"

    public var value: String
    
    public init(_ value: String) {
        self.value = value
    }
}
