public struct BuildOperationTaskEnded: Message {
    public static let name = "BUILD_TASK_ENDED"

    public var id: Int
    @MessageEnum public var status: Status
    public var signalled: Bool
    public var metrics: Metrics?
    
    public init(
        id: Int, 
        status: Status,
        signalled: Bool,
        metrics: Metrics?
    ) {
        self.id = id
        self.status = status
        self.signalled = signalled
        self.metrics = metrics
    }

    public enum Status: Hashable, CaseIterable, MessageEnumCodable {
        case succeeded
        case cancelled
        case failed
    }

    public struct Metrics: Codable {
        public var metrics: UInt64
        public var utime: UInt64
        public var stime: UInt64
        public var maxRSS: UInt64
        public var wcStartTime: UInt64
        public var wcDuration: UInt64

        public init(
            metrics: UInt64,
            utime: UInt64,
            stime: UInt64,
            maxRSS: UInt64,
            wcStartTime: UInt64,
            wcDuration: UInt64
        ) {
            self.metrics = metrics
            self.utime = utime
            self.stime = stime
            self.maxRSS = maxRSS
            self.wcStartTime = wcStartTime
            self.wcDuration = wcDuration
        }
    }
}
