import CustomDump
import XCTest

@testable import XCBProtocol

class BuildCommandMessagePayloadTests: XCTestCase {
    func test_encode() throws {
        let encoder = MessagePackEncoder()

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                MessageEnumWithPayload(wrappedValue: BuildCommandMessagePayload.preview)
            )),
            // [Int(7), nil]
            [0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07,  0xC0]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                MessageEnumWithPayload(wrappedValue: BuildCommandMessagePayload.build(style: .buildAndRun, skipDependencies: false))
            )),
            // [Int(0), [Int(1), false]]
            [0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,  0xC2]
        )
    }
}
