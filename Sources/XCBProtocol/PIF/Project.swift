public struct Project {
    public var guid: String
    public var isPackage: Bool
    public var xcodeprojPath: String // `Path`
    public var sourceRoot: String // `Path`
    public var targetSignatures: [String]
    public var groupTree: FileGroup
    public var buildConfigurations: [BuildConfiguration]
    public var defaultConfigurationName: String
    public var developmentRegion: String?
    public var classPrefix: String
    public var appPreferencesBuildSettings:
        [BuildConfiguration.MacroBindingSource]
    
    public init(
        guid: String,
        isPackage: Bool,
        xcodeprojPath: String,
        sourceRoot: String,
        targetSignatures: [String],
        groupTree: FileGroup,
        buildConfigurations: [BuildConfiguration],
        defaultConfigurationName: String,
        developmentRegion: String?,
        classPrefix: String,
        appPreferencesBuildSettings: [BuildConfiguration.MacroBindingSource]
    ) {
        self.guid = guid
        self.isPackage = isPackage
        self.xcodeprojPath = xcodeprojPath
        self.sourceRoot = sourceRoot
        self.targetSignatures = targetSignatures
        self.groupTree = groupTree
        self.buildConfigurations = buildConfigurations
        self.defaultConfigurationName = defaultConfigurationName
        self.developmentRegion = developmentRegion
        self.classPrefix = classPrefix
        self.appPreferencesBuildSettings = appPreferencesBuildSettings
    }
}
