public struct BoolResponse: Message {
    public static let name = "BOOL"

    public var value: Bool
    
    public init(_ value: Bool) {
        self.value = value
    }
}
