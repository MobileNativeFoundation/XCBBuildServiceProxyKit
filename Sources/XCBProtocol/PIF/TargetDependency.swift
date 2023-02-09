public struct TargetDependency {
    public var guid: String
    public var name: String?
    public var platformFilters: Set<PlatformFilter>

    public init(
        guid: String,
        name: String?,
        platformFilters: Set<PlatformFilter>
    ) {
        self.guid = guid
        self.name = name
        self.platformFilters = platformFilters
    }
}
