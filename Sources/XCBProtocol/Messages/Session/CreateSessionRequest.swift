public struct CreateSessionRequest: Message {
    public static let name = "CREATE_SESSION"

    public var name: String
    public var appPath: String? // `Path?`
    public var cachePath: String? // `Path?`
    public var inferiorProductsPath: String? // `Path?`

    public init(
        name: String,
        appPath: String?,
        cachePath: String?,
        inferiorProductsPath: String?
    ) {
        self.name = name
        self.appPath = appPath
        self.cachePath = cachePath
        self.inferiorProductsPath = inferiorProductsPath
    }
}
