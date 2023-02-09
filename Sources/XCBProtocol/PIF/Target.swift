public struct Target {
    public var guid: String
    public var name: String
    public var buildConfigurations: [BuildConfiguration]
    public var impartedBuildProperties: ImpartedBuildProperties
    public var dependencies: [TargetDependency]
    public var dynamicTargetVariantGuid: String?
    
    public init(
        guid: String,
        name: String,
        buildConfigurations: [BuildConfiguration],
        impartedBuildProperties: ImpartedBuildProperties,
        dependencies: [TargetDependency],
        dynamicTargetVariantGuid: String?
    ) {
        self.guid = guid
        self.name = name
        self.buildConfigurations = buildConfigurations
        self.impartedBuildProperties = impartedBuildProperties
        self.dependencies = dependencies
        self.dynamicTargetVariantGuid = dynamicTargetVariantGuid
    }
}
