public struct StringListResponse: Message {
    public static let name = "STRING_LIST"

    public var value: [String]
    
    public init(_ value: [String]) {
        self.value = value
    }
}
