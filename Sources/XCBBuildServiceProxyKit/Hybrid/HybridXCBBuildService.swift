import Foundation
import NIO
import os
import XCBProtocol

public final class HybridXCBBuildService<RequestHandler: HybridXCBBuildServiceRequestHandler> {
    private let name: String
    private let group: EventLoopGroup
    private let bootstrap: NIOPipeBootstrap
    
    // TODO: Move NIO specific stuff into class
    public init(name: String, group: EventLoopGroup, requestHandler: RequestHandler) throws {
        self.name = name
        self.group = group
        
        let xcbBuildServiceBootstrap = XCBBuildServiceBootstrap<RequestHandler.RequestPayload, RequestHandler.ResponsePayload>(group: group)
        
        let xcbBuildServiceFuture = xcbBuildServiceBootstrap.create()
        
        self.bootstrap = NIOPipeBootstrap(group: group)
            .channelInitializer { channel in
                xcbBuildServiceFuture.flatMap { xcbBuildService in
                    let framingHandler = RPCPacketCodec(label: "HybridXCBBuildService(\(name))")

                    // When the channel for XCBBuildService is closed, such as the process is terminated,
                    // close the channel for Xcode as well, which allows to terminate proxy process.
                    // Xcode then relaunch it when it's needed.
                    xcbBuildService.channel.closeFuture.whenComplete { _ in
                        channel.close(promise: nil)
                    }

                    return channel.pipeline.addHandlers([
                        // Bytes -> RPCPacket from Xcode
                        ByteToMessageHandler(framingHandler),
                        // RPCPacket -> Bytes to Xcode
                        MessageToByteHandler(framingHandler),
                        // RPCPacket -> RPCRequest from Xcode
                        RPCRequestDecoder<RequestHandler.RequestPayload>(),
                        // RPCResponse -> RPCPacket to Xcode
                        RPCResponseEncoder<RequestHandler.ResponsePayload>(),
                        // RPCRequests from Xcode, RPCResponses from XCBBuildService
                        HybridRPCRequestHandler<RequestHandler>(
                            xcbBuildService: xcbBuildService,
                            requestHandler: requestHandler
                        ),
                    ])
                }
            }
    }
    
    public func start() throws -> Channel {
        let channel = try bootstrap.withPipes(inputDescriptor: STDIN_FILENO, outputDescriptor: STDOUT_FILENO).wait()
        
        os_log(.info, "\(self.name) started and listening on STDIN")
        
        return channel
    }
    
    public func stop() {
        do {
            try group.syncShutdownGracefully()
        } catch {
            os_log(.error, "Error shutting down: \(error.localizedDescription)")
            exit(0)
        }
        os_log(.info, "\(self.name) stopped")
    }
}
