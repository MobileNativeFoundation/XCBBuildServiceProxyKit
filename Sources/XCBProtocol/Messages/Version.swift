public struct Version: RawRepresentable {
    public var rawValue: [UInt]

    public init(rawValue: [UInt]) {
        self.rawValue = rawValue
    }
}
