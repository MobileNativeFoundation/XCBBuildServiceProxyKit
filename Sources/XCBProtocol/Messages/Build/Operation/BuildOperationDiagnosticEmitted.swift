public struct BuildOperationDiagnosticEmitted: Message {
    public static let name = "BUILD_DIAGNOSTIC_EMITTED"

    public var kind: Kind
    public var location: Diagnostic.Location
    public var message: String

    // TODO: Computed `alternativeMessage`
//    public var alternativeMessage: String?

    public var locationContext: Diagnostic.LocationContext

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
    
    public enum Kind: Int {
        case note
        case warning
        case error
        case remark
    }

    public enum Component {
        case clangCompiler(categoryName: String)
        case `default`
        case packageResolution
        case targetIntegrity
    }
}

public struct Diagnostic {
    // TODO: ID?
    var behavior: Behavior
    var location: Location
    var sourceRanges: [SourceRange]
    var data: DiagnosticData
    var appendToOutputStream: Bool
    var childDiagnostics: [Diagnostic]
    var fixIts: [FixIt]

    enum Behavior {
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

    public struct FixIt {
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

        public struct BuildFileAndPhase {
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

    public struct SourceRange {
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
