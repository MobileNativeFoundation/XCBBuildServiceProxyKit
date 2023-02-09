public struct BuildConfiguration {
    public var name: String
    public var buildSettings: [MacroBindingSource]
    public var baseConfigurationFileReferenceGUID: String?

    public init(
        name: String,
        buildSettings: [MacroBindingSource],
        baseConfigurationFileReferenceGUID: String?
    ) {
        self.name = name
        self.buildSettings = buildSettings
        self.baseConfigurationFileReferenceGUID =
            baseConfigurationFileReferenceGUID
    }

    public struct MacroBindingSource {
        public var key: String
        public var value: MacroExpressionSource
        
        public init(key: String, value: MacroExpressionSource) {
            self.key = key
            self.value = value
        }
    }
}
