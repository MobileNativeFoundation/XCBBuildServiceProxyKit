public struct PreviewInfoResponse: Message {
    public static let name = "PREVIEW_INFO_RECEIVED"

    public var targetID: String

    public var output: [PreviewInfoMessagePayload]
    
    public init(targetID: String, output: [PreviewInfoMessagePayload]) {
        self.targetID = targetID
        self.output = output
    }
}

public struct PreviewInfoMessagePayload {
    /// e.g. `"macosx10.14"`
    public var sdkRoot: String

    /// e.g. `"macos"`, `"iphonesimulator"`
    public var sdkVariant: String?

    /// e.g. `"normal"`
    public var buildVariant: String

    /// e.g. `"x86_64"`
    public var architecture: String

    /// e.g. `["/Applications/Xcode-11.3.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/swiftc", "-enforce-exclusivity=checked", ...]`
    public var compileCommandLine: [String]

    /// e.g. `["/Applications/Xcode-11.3.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang", "-target", ...]`
    public var linkCommandLine: [String]

    /// e.g. `"/Users/USER/Library/Developer/Xcode/DerivedData/PROJECT-hash/Build/Intermediates.noindex/Previews/TARGET_NAME/Intermediates.noindex/PROJECT_NAME.build/Debug-iphonesimulator/TARGET_NAME.build/Objects-normal/x86_64/SOURCE_FILE.__XCPREVIEW_THUNKSUFFIX__.preview-thunk.swift"`
    public var thunkSourceFile: String // `Path`

    /// e.g. `"/Users/USER/Library/Developer/Xcode/DerivedData/PROJECT-hash/Build/Intermediates.noindex/Previews/TARGET_NAME/Intermediates.noindex/PROJECT_NAME.build/Debug-iphonesimulator/TARGET_NAME.build/Objects-normal/x86_64/SOURCE_FILE.__XCPREVIEW_THUNKSUFFIX__.preview-thunk.o"`
    public var thunkObjectFile: String // `Path`

    /// e.g. `"/Users/USER/Library/Developer/Xcode/DerivedData/PROJECT-hash/Build/Intermediates.noindex/Previews/TARGET_NAME/Intermediates.noindex/PROJECT_NAME.build/Debug-iphonesimulator/TARGET_NAME.build/Objects-normal/x86_64/SOURCE_FILE.__XCPREVIEW_THUNKSUFFIX__.preview-thunk.dylib"`
    public var thunkLibrary: String // `Path`

    public var pifGUID: String
    
    public init(
        sdkRoot: String,
        buildVariant: String,
        architecture: String,
        compileCommandLine: [String],
        linkCommandLine: [String],
        thunkSourceFile: String,
        thunkObjectFile: String,
        thunkLibrary: String,
        pifGUID: String
    ) {
        self.sdkRoot = sdkRoot
        self.buildVariant = buildVariant
        self.architecture = architecture
        self.compileCommandLine = compileCommandLine
        self.linkCommandLine = linkCommandLine
        self.thunkSourceFile = thunkSourceFile
        self.thunkObjectFile = thunkObjectFile
        self.thunkLibrary = thunkLibrary
        self.pifGUID = pifGUID
    }
}
