import OrderedCollections

public struct BuildRequestMessagePayload: Codable {
    public var parameters: BuildParametersMessagePayload
    public var configuredTargets: [ConfiguredTargetMessagePayload]
    public var continueBuildingAfterErrors: Bool
    public var hideShellScriptEnvironment: Bool
    public var useParallelTargets: Bool
    public var useImplicitDependencies: Bool
    public var useDryRun: Bool
    public var showNonLoggedProgress: Bool
    public var buildPlanDiagnosticsDirPath: String?
    @MessageEnumWithPayload public var buildCommand: BuildCommandMessagePayload
    @MessageEnum public var schemeCommand: SchemeCommandMessagePayload
    public var containerPath: String?
    public var buildDescriptionID: String?
    public var qos: MessageEnum<BuildQoSMessagePayload>?
    public var jsonRepresentation: String?

    public init(
        parameters: BuildParametersMessagePayload,
        configuredTargets: [ConfiguredTargetMessagePayload],
        continueBuildingAfterErrors: Bool,
        hideShellScriptEnvironment: Bool,
        useParallelTargets: Bool,
        useImplicitDependencies: Bool,
        useDryRun: Bool,
        showNonLoggedProgress: Bool,
        buildPlanDiagnosticsDirPath: String?,
        buildCommand: BuildCommandMessagePayload,
        schemeCommand: SchemeCommandMessagePayload,
        containerPath: String?,
        buildDescriptionID: String?,
        qos: BuildQoSMessagePayload?,
        jsonRepresentation: String?
    ) {
        self.parameters = parameters
        self.configuredTargets = configuredTargets
        self.continueBuildingAfterErrors = continueBuildingAfterErrors
        self.hideShellScriptEnvironment = hideShellScriptEnvironment
        self.useParallelTargets = useParallelTargets
        self.useImplicitDependencies = useImplicitDependencies
        self.useDryRun = useDryRun
        self.showNonLoggedProgress = showNonLoggedProgress
        self.buildPlanDiagnosticsDirPath = buildPlanDiagnosticsDirPath
        self.buildCommand = buildCommand
        self.schemeCommand = schemeCommand
        self.containerPath = containerPath
        self.buildDescriptionID = buildDescriptionID
        self.qos = qos.map(MessageEnum.init)
        self.jsonRepresentation = jsonRepresentation
    }
}

public enum BuildCommandMessagePayload {
    case build(style: BuildTaskStyleMessagePayload, skipDependencies: Bool)
    case generateAssemblyCode(buildOnlyTheseFiles: [String])
    case generatePreprocessedFile(buildOnlyTheseFiles: [String])
    case singleFileBuild(buildOnlyTheseFiles: [String])
    case prepareForIndexing(buildOnlyTheseTargets: [String]?, enableIndexBuildArena: Bool)
    case cleanBuildFolder(style: BuildLocationStyleMessagePayload)
    case migrate
    case preview
}

// TODO: This should return an Int as the tag for MsgPack and String for JSON
extension BuildCommandMessagePayload: MessageEnumWithPayloadCodable {
    public enum Command: Hashable, CaseIterable {
        case build
        case generateAssemblyCode
        case generatePreprocessedFile
        case singleFileBuild
        case prepareForIndexing
        case migrate
        case cleanBuildFolder
        case preview
    }

    enum CodingKeys: String, CodingKey {
        case command
        case payload

        case files
        case targets
        case style
        case skipDependencies
        case enableIndexBuildArena
    }

    public func encode(tagInt: Int, to encoder: Encoder) throws {
        var container = encoder
            .container(keyedBy: CodingKeys.self)
        try container.encode(tagInt, forKey: .command)

        switch self {
        case .build(let style, let skipDependencies):
            var payloadContainer = container
                .nestedContainer(keyedBy: CodingKeys.self, forKey: .payload)
            try payloadContainer.encode(MessageEnum(wrappedValue: style), forKey: .style)
            try payloadContainer.encode(skipDependencies, forKey: .skipDependencies)
        case .generateAssemblyCode(let files):
            try container.encode(files, forKey: .files)
        case .generatePreprocessedFile(let files):
            try container.encode(files, forKey: .files)
        case .singleFileBuild(let files):
            try container.encode(files, forKey: .files)
        case .prepareForIndexing(let targets, let enableIndexBuildArena):
            var payloadContainer = container
                .nestedContainer(keyedBy: CodingKeys.self, forKey: .payload)
            try payloadContainer.encode(targets, forKey: .targets)
            try payloadContainer.encode(enableIndexBuildArena, forKey: .enableIndexBuildArena)
        case .cleanBuildFolder(let style):
            try container.encode(MessageEnum(wrappedValue: style), forKey: .style)
        case .migrate:
            try container.encodeNil(forKey: .payload)
        case .preview:
            try container.encodeNil(forKey: .payload)
        }
    }

    public static func tagCases() -> Command.AllCases {
        return [
            .build,
            .generateAssemblyCode,
            .generatePreprocessedFile,
            .singleFileBuild,
            .prepareForIndexing,
            .migrate,
            .cleanBuildFolder,
            .preview,
        ]
    }

    public func tag() -> Command {
        switch self {
        case .build:
            return .build
        case .generateAssemblyCode:
            return .generateAssemblyCode
        case .generatePreprocessedFile:
            return .generatePreprocessedFile
        case .singleFileBuild:
            return .singleFileBuild
        case .prepareForIndexing:
            return .prepareForIndexing
        case .cleanBuildFolder:
            return .cleanBuildFolder
        case .migrate:
            return .migrate
        case .preview:
            return .preview
        }
    }
}

public enum BuildLocationStyleMessagePayload: Hashable, CaseIterable, MessageEnumCodable {
    case regular
    case legacy
}

public enum BuildQoSMessagePayload: Hashable, CaseIterable, MessageEnumCodable {
    case background
    case utility
    case `default`
    case userInitiated
}

public enum BuildTaskStyleMessagePayload: Hashable, CaseIterable, MessageEnumCodable {
    case buildOnly
    case buildAndRun
}

public enum SchemeCommandMessagePayload: Hashable, CaseIterable, MessageEnumCodable {
    case launch
    case test
    case profile
    case archive
}

public struct ConfiguredTargetMessagePayload: Codable {
    public var guid: String
    public var parameters: BuildParametersMessagePayload?

    public init(guid: String, parameters: BuildParametersMessagePayload?) {
        self.guid = guid
        self.parameters = parameters
    }
}

public struct BuildParametersMessagePayload: Codable {
    /// e.g. `"build"`, `"clean"`
    @MessageEnum public var action: Action

    /// e.g. `"Debug"`, `"Release"`
    public var configuration: String?

    public var activeRunDestination: RunDestinationInfo?

    /// e.g. `"x86_64"`, `"arm64"`
    public var activeArchitecture: String?

    public var arenaInfo: ArenaInfo?

    public var overrides: SettingsOverridesMessagePayload

    public init(
        action: Action,
        configuration: String?,
        activeRunDestination: RunDestinationInfo?,
        activeArchitecture: String?,
        arenaInfo: ArenaInfo?,
        overrides: SettingsOverridesMessagePayload
    ) {
        self.action = action
        self.configuration = configuration
        self.activeRunDestination = activeRunDestination
        self.activeArchitecture = activeArchitecture
        self.arenaInfo = arenaInfo
        self.overrides = overrides
    }

    public enum Action: String, CaseIterable, MessageEnumCodable {
        case analyze
        case archive
        case clean
        case build
        case exportLoc
        case indexBuild
        case install
        case installAPI
        case installHeaders
        case installLoc
        case installSource
        case migrateSwift
        case docBuild
    }
}

public struct RunDestinationInfo: Codable {
    /// e.g. `"macosx"`
    public var platform: Platform

    /// e.g. `"macosx10.14"`
    public var sdk: String

    /// e.g. `"macos"`, `"iphonesimulator"`
    public var sdkVariant: String?

    /// e.g. `"x86_64"`, `"arm64"`
    public var targetArchitecture: String

    /// e.g. `["armv7s", "arm64"]`
    public var supportedArchitectures: OrderedSet<String>

    public var disableOnlyActiveArch: Bool

    public init(
        platform: Platform,
        sdk: String,
        sdkVariant: String,
        targetArchitecture: String,
        supportedArchitectures: OrderedSet<String>,
        disableOnlyActiveArch: Bool
    ) {
        self.platform = platform
        self.sdk = sdk
        self.sdkVariant = sdkVariant
        self.targetArchitecture = targetArchitecture
        self.supportedArchitectures = supportedArchitectures
        self.disableOnlyActiveArch = disableOnlyActiveArch
    }
}

public struct ArenaInfo: Codable {
    /// e.g. `"/Users/USER/Library/Developer/Xcode/DerivedData"`
    public var derivedDataPath: String // `Path`

    /// e.g. `"/Users/USER/Library/Developer/Xcode/DerivedData/PROJECT-HASH/Build/Products"`
    public var buildProductsPath: String// `Path`

    /// e.g. `"/Users/USER/Library/Developer/Xcode/DerivedData/PROJECT-HASH/Build/Intermediates.noindex"`
    public var buildIntermediatesPath: String// `Path`

    /// e.g. `"/Users/USER/Library/Developer/Xcode/DerivedData/PROJECT-HASH/Build/Intermediates.noindex/PrecompiledHeaders"`
    public var pchPath: String // `Path`

    /// e.g. `"/Users/USER/Library/Developer/Xcode/DerivedData/PROJECT-HASH/Index/PrecompiledHeaders"`
    public var indexPCHPath: String // `Path`

    /// e.g. `"/Users/USER/Library/Developer/Xcode/DerivedData/PROJECT-HASH/Index/DataStore"`
    public var indexDataStoreFolderPath: String? // `Path`

    public var indexEnableDataStore: Bool

    public init(
        derivedDataPath: String,
        buildProductsPath: String,
        buildIntermediatesPath: String,
        pchPath: String,
        indexPCHPath: String,
        indexDataStoreFolderPath: String?,
        indexEnableDataStore: Bool
    ) {
        self.derivedDataPath = derivedDataPath
        self.buildProductsPath = buildProductsPath
        self.buildIntermediatesPath = buildIntermediatesPath
        self.pchPath = pchPath
        self.indexPCHPath = indexPCHPath
        self.indexDataStoreFolderPath = indexDataStoreFolderPath
        self.indexEnableDataStore = indexEnableDataStore
    }
}

public struct SettingsOverridesMessagePayload: Codable {
    /// e.g. `["TARGET_DEVICE_MODEL": "iPhone12,5", "TARGET_DEVICE_OS_VERSION": "13.3"]`
    public var synthesized: [String: String]

    public var commandLine: [String: String]

    public var commandLineConfigPath: String? // `Path?`

    public var commandLineConfig: [String: String]

    public var environmentConfigPath: String? // `Path?`

    public var environmentConfig: [String: String]

    /// e.g. `"org.swift.515120200323a"`
    public var toolchainOverride: String?

    public init(
        synthesized: [String: String],
        commandLine: [String: String],
        commandLineConfigPath: String?,
        commandLineConfig: [String: String],
        environmentConfigPath: String?,
        environmentConfig: [String: String],
        toolchainOverride: String?
    ) {
        self.synthesized = synthesized
        self.commandLine = commandLine
        self.commandLineConfigPath = commandLineConfigPath
        self.commandLineConfig = commandLineConfig
        self.environmentConfigPath = environmentConfigPath
        self.environmentConfig = environmentConfig
        self.toolchainOverride = toolchainOverride
    }
}
