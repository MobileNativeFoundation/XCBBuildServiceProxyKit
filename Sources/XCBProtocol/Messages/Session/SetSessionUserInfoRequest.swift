public struct SetSessionUserInfoRequest: SessionMessage, Decodable {
    public static let name = "SET_SESSION_USER_INFO"

    public var sessionHandle: String
    public var user: String
    public var group: String
    public var uid: Int
    public var gid: Int
    public var home: String
    public var processEnvironment: [String: String]
    public var buildSystemEnvironment: [String: String]

    public init(
        sessionHandle: String,
        user: String,
        group: String,
        uid: Int,
        gid: Int,
        home: String,
        processEnvironment: [String: String],
        buildSystemEnvironment: [String: String]
    ) {
        self.sessionHandle = sessionHandle
        self.user = user
        self.group = group
        self.uid = uid
        self.gid = gid
        self.home = home
        self.processEnvironment = processEnvironment
        self.buildSystemEnvironment = buildSystemEnvironment
    }
}
