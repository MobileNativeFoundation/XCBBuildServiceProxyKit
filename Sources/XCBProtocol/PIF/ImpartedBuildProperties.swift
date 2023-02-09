public struct ImpartedBuildProperties {
    public var buildSettings: [BuildConfiguration.MacroBindingSource]

    public init(buildSettings: [BuildConfiguration.MacroBindingSource]) {
        self.buildSettings = buildSettings
    }
}
