public struct SetSessionUserPreferencesRequest: SessionMessage, Codable {
    public static let name = "SET_SESSION_USER_PREFERENCES"

    public var sessionHandle: String
    public var enableDebugActivityLogs: Bool
    public var enableBuildDebugging: Bool
    public var enableBuildSystemCaching: Bool
    @MessageEnum public var activityTextShorteningLevel: ActivityTextShorteningLevel
    public var enableSwiftBuildSystemIntegration: Bool
    public var usePerConfigurationBuildLocations: Bool?

    public init(
        sessionHandle: String,
        enableDebugActivityLogs: Bool,
        enableBuildDebugging: Bool,
        enableBuildSystemCaching: Bool,
        activityTextShorteningLevel: ActivityTextShorteningLevel,
        enableSwiftBuildSystemIntegration: Bool,
        usePerConfigurationBuildLocations: Bool?
    ) {
        self.sessionHandle = sessionHandle
        self.enableDebugActivityLogs = enableDebugActivityLogs
        self.enableBuildDebugging = enableBuildDebugging
        self.enableBuildSystemCaching = enableBuildSystemCaching
        self.activityTextShorteningLevel = activityTextShorteningLevel
        self.enableSwiftBuildSystemIntegration =
            enableSwiftBuildSystemIntegration
        self.usePerConfigurationBuildLocations =
            usePerConfigurationBuildLocations
    }
}

public enum ActivityTextShorteningLevel: Hashable, CaseIterable, MessageEnumCodable {
    case legacy
    case buildCountsOnly
    case allDynamicText
    case full
}
