public struct ErrorResponse: Message {
    public static let name = "ERROR"

    public var description: String
    
    public init(_ description: String) {
        self.description = description
    }
}
