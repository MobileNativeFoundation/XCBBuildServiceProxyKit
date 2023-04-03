public struct BuildOperationDiagnosticEmitted: Message {
    public static let name = "BUILD_DIAGNOSTIC_EMITTED"

    @MessageEnum public var kind: Kind
    @MessageEnumWithPayload public var location: Diagnostic.Location
    public var message: String

    // TODO: Computed `alternativeMessage`
//    public var alternativeMessage: String?

    @MessageEnumWithPayload public var locationContext: Diagnostic.LocationContext

    /// e.g. `"default"`
    public var component: Component

    /// If `true`, the diagnostic is attached to the output instead of showing
    /// as a new entry.
    public var appendToOutputStream: Bool

    public var sourceRanges: [Diagnostic.SourceRange]

    public var fixIts: [Diagnostic.FixIt]

    public var childDiagnostics: [BuildOperationDiagnosticEmitted]
    
    public init(
        kind: Kind,
        location: Diagnostic.Location,
        message: String,
        locationContext: Diagnostic.LocationContext,
        component: Component,
        appendToOutputStream: Bool,
        sourceRanges: [Diagnostic.SourceRange],
        fixIts: [Diagnostic.FixIt],
        childDiagnostics: [BuildOperationDiagnosticEmitted]
    ) {
        self.kind = kind
        self.location = location
        self.message = message
        self.locationContext = locationContext
        self.component = component
        self.appendToOutputStream = appendToOutputStream
        self.sourceRanges = sourceRanges
        self.fixIts = fixIts
        self.childDiagnostics = childDiagnostics
    }
    
    public enum Kind: Hashable, CaseIterable, MessageEnumCodable {
        case note
        case warning
        case error
        case remark
    }

    public enum Component: Codable {
        case clangCompiler(categoryName: String)
        case `default`
        case packageResolution
        case targetIntegrity
    }
}

public struct Diagnostic: Codable {
    // TODO: ID?
    var behavior: Behavior
    @MessageEnumWithPayload var location: Location
    var sourceRanges: [SourceRange]
//    var data: DiagnosticData
    var appendToOutputStream: Bool
    var childDiagnostics: [Diagnostic]
    var fixIts: [FixIt]

    enum Behavior: Codable {
        case error
        case warning
        case note
        case ignored
        case remark
    }

    public enum FileLocation {
        case textual(line: Int, column: Int?)
        case object(identifier: String)
    }

    public struct FixIt: Codable {
        public var sourceRange: SourceRange
        public var textToInsert: String

        public init(sourceRange: SourceRange, newText: String) {
            self.sourceRange = sourceRange
            textToInsert = newText
        }
    }

    public enum Location {
        case path(String /* `Path` */, fileLocation: FileLocation?)
        case buildSettings(names: [String])
        case buildFiles([BuildFileAndPhase], targetGUID: String)
        case unknown

        public struct BuildFileAndPhase: Codable {
            public var buildFileGUID: String
            public var buildPhaseGUID: String

            public init(buildFileGUID: String, buildPhaseGUID: String) {
                self.buildFileGUID = buildFileGUID
                self.buildPhaseGUID = buildPhaseGUID
            }
        }
    }

    public enum LocationContext {
        case task(taskID: Int, targetID: Int)
        case target(targetID: Int)
        case globalTask(taskID: Int)
        case global
    }

    public struct SourceRange: Codable {
        public var path: String // `Path`
        public var startLine: Int
        public var startColumn: Int
        public var endLine: Int
        public var endColumn: Int

        public init(
            path: String,
            startLine: Int,
            startColumn: Int,
            endLine: Int,
            endColumn: Int
        ) {
            self.path = path
            self.startLine = startLine
            self.startColumn = startColumn
            self.endLine = endLine
            self.endColumn = endColumn
        }
    }
}

public protocol DiagnosticData {
}

// MARK: - MessageEnumWithPayloadCodable

extension Diagnostic.FileLocation: MessageEnumWithPayloadCodable {
    public enum Location: Hashable, CaseIterable {
        case textual
        case object
    }

    enum CodingKeys: String, CodingKey {
        case location
        case payload

        case line
        case column
        case identifier
    }

    public typealias TagEnums = Location.AllCases

    public func tag() -> Location {
        switch self {
        case .textual: return .textual
        case .object: return .object
        }
    }

    public func encode(tagInt: Int, to encoder: Encoder) throws {
        var container = encoder
            .container(keyedBy: CodingKeys.self)
        try container.encode(tagInt, forKey: .location)

        switch self {
        case .textual(let line, let column):
            var payloadContainer = container
                .nestedContainer(keyedBy: CodingKeys.self, forKey: .payload)
            try payloadContainer.encode(line, forKey: .line)
            try payloadContainer.encode(column, forKey: .column)
        case .object(let identifier):
            try container.encode(identifier, forKey: .identifier)
        }
    }
}

extension Diagnostic.Location: MessageEnumWithPayloadCodable {
    public enum Location: Hashable, CaseIterable {
        case path
        case buildSettings
        case buildFiles
        case unknown
    }

    enum CodingKeys: String, CodingKey {
        case location
        case payload

        case path
        case fileLocation
        case buildSettings
        case buildFiles
        case targetGUID
    }

    public typealias TagEnums = Location.AllCases

    public func tag() -> Location {
        switch self {
        case .path: return .path
        case .buildSettings: return .buildSettings
        case .buildFiles: return .buildFiles
        case .unknown: return .unknown
        }
    }

    public func encode(tagInt: Int, to encoder: Encoder) throws {
        var container = encoder
            .container(keyedBy: CodingKeys.self)
        try container.encode(tagInt, forKey: .location)

        switch self {
        case .path(let path, let fileLocation):
            var payloadContainer = container
                .nestedContainer(keyedBy: CodingKeys.self, forKey: .payload)
            try payloadContainer.encode(path, forKey: .path)
            try payloadContainer.encode(
                fileLocation.map(MessageEnumWithPayload.init),
                forKey: .fileLocation
            )
        case .buildSettings(let names):
            try container.encode(names, forKey: .buildSettings)
        case .buildFiles(let buildFiles, let targetGUID):
            var payloadContainer = container
                .nestedContainer(keyedBy: CodingKeys.self, forKey: .payload)
            try payloadContainer.encode(buildFiles, forKey: .buildFiles)
            try payloadContainer.encode(targetGUID, forKey: .targetGUID)
        case .unknown:
            try container.encodeNil(forKey: .payload)
        }
    }
}

extension Diagnostic.LocationContext: MessageEnumWithPayloadCodable {
    public enum Context: Hashable, CaseIterable {
        case task
        case target
        case globalTask
        case global
    }

    enum CodingKeys: String, CodingKey {
        case context
        case payload

        case taskID
        case targetID
    }

    public typealias TagEnums = Context.AllCases

    public func tag() -> Context {
        switch self {
        case .task: return .task
        case .target: return .target
        case .globalTask: return .globalTask
        case .global: return .global
        }
    }

    public func encode(tagInt: Int, to encoder: Encoder) throws {
        var container = encoder
            .container(keyedBy: CodingKeys.self)
        try container.encode(tagInt, forKey: .context)

        switch self {
        case .task(let taskID, let targetID):
            var payloadContainer = container
                .nestedContainer(keyedBy: CodingKeys.self, forKey: .payload)
            try payloadContainer.encode(taskID, forKey: .taskID)
            try payloadContainer.encode(targetID, forKey: .targetID)
        case .target(let targetID):
            try container.encode(targetID, forKey: .targetID)
        case .globalTask(let taskID):
            try container.encode(taskID, forKey: .taskID)
        case .global:
            try container.encodeNil(forKey: .payload)
        }
    }
}
