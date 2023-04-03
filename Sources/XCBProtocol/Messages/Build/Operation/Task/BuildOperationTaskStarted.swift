public struct BuildOperationTaskStarted: Message {
    public static let name = "BUILD_TASK_STARTED"

    /// Starts from `1` within a build.
    public var id: Int

    public var targetID: Int?
    public var parentID: Int?
    public var info: BuildOperationTaskInfo

    public init(
        id: Int,
        targetID: Int?,
        parentID: Int?,
        info: BuildOperationTaskInfo
    ) {
        self.id = id
        self.targetID = targetID
        self.parentID = parentID
        self.info = info
    }
}

public struct BuildOperationTaskInfo: Codable {
    /// e.g. `"Swift Compiler"`, `"Shell Script Invocation"`
    public var taskName: String

    /// Used in `BuildOperationTaskUpToDate`. Seems to be consistent.
    public var signature: ByteString

    /// e.g. `"CompileSwift normal x86_64 /Users/USER/Desktop/BazelXCBuildServer/Sources/XCBProtocol/Response.swift", "PhaseScriptExecution SwiftLint /Users/USER/Library/Developer/Xcode/DerivedData/PROJECT-HASH/Build/Intermediates.noindex/PROJECT.build/Debug-iphonesimulator/SCRIPT.build/Script-9A635388D017DF17C1E0081A.sh"`
    public var ruleInfo: String

    /// e.g. `"Compile /Users/USER/Desktop/BazelXCBuildServer/Sources/XCBProtocol/Response.swift", "Run custom shell script 'SwiftLint'"`
    public var executionDescription: String

    /// e.g. `"/Users/USER/Desktop/BazelXCBuildServer/Sources/XCBProtocol/Response.swift"`
    public var interestingPath: String?

    /// e.g. `"    cd /Users/USER/Desktop/BazelXCBuildServer\n/Applications/Xcode-11.3.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swift -frontend -c ..."`
    public var commandLineDisplayString: String?

    public var serializedDiagnosticsPaths: [String] // `[Path]`

    public init(
        taskName: String,
        signature: ByteString,
        ruleInfo: String,
        executionDescription: String,
        interestingPath: String?,
        commandLineDisplayString: String?,
        serializedDiagnosticsPaths: [String]
    ) {
        self.taskName = taskName
        self.signature = signature
        self.ruleInfo = ruleInfo
        self.executionDescription = executionDescription
        self.commandLineDisplayString = commandLineDisplayString
        self.interestingPath = interestingPath
        self.serializedDiagnosticsPaths = serializedDiagnosticsPaths
    }
}
