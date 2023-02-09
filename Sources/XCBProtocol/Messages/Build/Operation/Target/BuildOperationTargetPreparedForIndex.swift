import Foundation

public struct BuildOperationTargetPreparedForIndex: Message {
    public static let name = "BUILD_TARGET_PREPARED_FOR_INDEX"

    public var targetGUID: String
    public var info: PreparedForIndexResultInfo
}

public struct PreparedForIndexResultInfo {
    let timestamp: Date
}
