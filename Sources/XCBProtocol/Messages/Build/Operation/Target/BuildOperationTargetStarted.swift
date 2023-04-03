// FIXME: JSON Encode
public struct BuildOperationTargetStarted: Message {
    public static let name = "BUILD_TARGET_STARTED"

    public var id: Int

    /// Used in `CreateBuildRequest` and `BuildOperationTargetUpToDate`.
    public var guid: String

    public var info: BuildOperationTargetInfo
    
    public init(id: Int, guid: String, info: BuildOperationTargetInfo) {
        self.id = id
        self.guid = guid
        self.info = info
    }
}

public struct BuildOperationProjectInfo: Codable {
    public var name: String
    public var path: String
    public var isPackage: Bool
    public var isNameUniqueInWorkspace: Bool
    
    public init(
        name: String, 
        path: String, 
        isPackage: Bool, 
        isNameUniqueInWorkspace: Bool
    ) {
        self.name = name
        self.path = path
        self.isPackage = isPackage
        self.isNameUniqueInWorkspace = isNameUniqueInWorkspace
    }
}

public struct BuildOperationTargetInfo: Codable {
    public var name: String

    /// e.g. `"Native"`, `"Aggregate"`
    public var typeName: String

    public var projectInfo: BuildOperationProjectInfo

    /// e.g. `"Debug"`
    public var configurationName: String

    public var configurationIsDefault: Bool

    /// e.g. `"/Applications/Xcode-11.3.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator13.2.sdk"`
    public var sdkRoot: String?
    
    public init(
        name: String,
        typeName: String,
        projectInfo: BuildOperationProjectInfo,
        configurationName: String,
        configurationIsDefault: Bool,
        sdkRoot: String?
    ) {
        self.name = name
        self.typeName = typeName
        self.projectInfo = projectInfo
        self.configurationName = configurationName
        self.configurationIsDefault = configurationIsDefault
        self.sdkRoot = sdkRoot
    }
}
