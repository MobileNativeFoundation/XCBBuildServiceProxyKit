public struct PlatformFilter: Hashable {
    public var platform: String
    public var environment: String

    public init(platform: String, environment: String) {
        self.platform = platform
        self.environment = environment
    }
}
