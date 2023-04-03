public struct Version: RawRepresentable, Codable {
    public var rawValue: [UInt]

    public init(rawValue: [UInt]) {
        self.rawValue = rawValue
    }
}
