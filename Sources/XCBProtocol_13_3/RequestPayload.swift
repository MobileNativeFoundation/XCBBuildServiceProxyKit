import Foundation
import MessagePack
import XCBProtocol

public enum RequestPayload {
    case createSession(CreateSessionRequest)
    case transferSessionPIFRequest(TransferSessionPIFRequest)
    case setSessionSystemInfo(SetSessionSystemInfoRequest)
    case setSessionUserInfo(SetSessionUserInfoRequest)
    
    case createBuildRequest(CreateBuildRequest)
    case buildStartRequest(BuildStartRequest)
    case buildCancelRequest(BuildCancelRequest)
    
    case indexingInfoRequest(IndexingInfoRequest)
    
    case previewInfoRequest(PreviewInfoRequest)
    
    case unknownRequest(UnknownRequest)
}

public struct UnknownRequest {
    public let values: [MessagePackValue]
}

// MARK: - Encoding

extension RequestPayload: XCBProtocol.RequestPayload {
    public static func unknownRequest(values: [MessagePackValue]) -> Self {
        return .unknownRequest(.init(values: values))
    }
    
    public init(values: [MessagePackValue], indexPath: IndexPath) throws {
        let name = try values.parseString(indexPath: indexPath + IndexPath(index: 0))
        let bodyIndexPath = indexPath + IndexPath(index: 1)
        
        switch name {
        case "CREATE_SESSION": self = .createSession(try values.parseObject(indexPath: bodyIndexPath))
        case "TRANSFER_SESSION_PIF_REQUEST": self = .transferSessionPIFRequest(try values.parseObject(indexPath: bodyIndexPath))
        case "SET_SESSION_SYSTEM_INFO": self = .setSessionSystemInfo(try values.parseObject(indexPath: indexPath))
        case "SET_SESSION_USER_INFO":
            let data = try values.parseBinary(indexPath: bodyIndexPath)
            self = .setSessionUserInfo(try JSONDecoder().decode(SetSessionUserInfoRequest.self, from: data))
            
        case "CREATE_BUILD":
            let data = try values.parseBinary(indexPath: bodyIndexPath)
            self = .createBuildRequest(try JSONDecoder().decode(CreateBuildRequest.self, from: data))
            
        case "BUILD_START": self = .buildStartRequest(try values.parseObject(indexPath: bodyIndexPath))
        case "BUILD_CANCEL": self = .buildCancelRequest(try values.parseObject(indexPath: bodyIndexPath))
            
        case "INDEXING_INFO_REQUESTED":
            let data = try values.parseBinary(indexPath: bodyIndexPath)
            self = .indexingInfoRequest(try JSONDecoder().decode(IndexingInfoRequest.self, from: data))
            
        case "PREVIEW_INFO_REQUESTED":
            let data = try values.parseBinary(indexPath: bodyIndexPath)
            self = .previewInfoRequest(try JSONDecoder().decode(PreviewInfoRequest.self, from: data))
            
        default: self = .unknownRequest(.init(values: values))
        }
    }
    
    public var createSessionXcodePath: String? {
        switch self {
        case .createSession(let message): return message.appPath
        default: return nil
        }
    }
}
