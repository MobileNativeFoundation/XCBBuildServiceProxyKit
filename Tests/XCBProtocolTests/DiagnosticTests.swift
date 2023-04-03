import CustomDump
import XCTest

@testable import XCBProtocol

class DiagnosticsTests: XCTestCase {
    func test_encode_Location() throws {
        let encoder = MessagePackEncoder()

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                MessageEnumWithPayload(wrappedValue: Diagnostic.Location.path("some", fileLocation: nil))
            )),
            // [0, ["some", nil]]
            [0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x92,  0xA4, 0x73, 0x6F, 0x6D, 0x65,  0xC0]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                MessageEnumWithPayload(wrappedValue: Diagnostic.Location.path("some", fileLocation: .textual(line: 42, column: nil)))
            )),
            // [0, ["some", [0, [42, nil]]]]
            [0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x92,  0xA4, 0x73, 0x6F, 0x6D, 0x65,  0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2A,  0xC0]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                MessageEnumWithPayload(wrappedValue: Diagnostic.Location.buildSettings(names: ["a", "42"]))
            )),
            // [1, ["a", "42"]]
            [0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,  0x92,  0xA1, 0x61,  0xA2, 0x34, 0x32]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                MessageEnumWithPayload(wrappedValue: Diagnostic.Location.buildFiles([.init(buildFileGUID: "xyz", buildPhaseGUID: "123")], targetGUID: "abcd"))
            )),
            // [2, [[["xyz", "123"]], "abcd"]]
            [0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02,  0x92,  0x91,  0x92,  0xA3, 0x78, 0x79, 0x7A,  0xA3, 0x31, 0x32, 0x33,  0xA4, 0x61, 0x62, 0x63, 0x64]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                MessageEnumWithPayload(wrappedValue: Diagnostic.Location.unknown)
            )),
            // [3, nil]
            [0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03,  0xC0]
        )
    }

    func test_encode_LocationContext() throws {
        let encoder = MessagePackEncoder()

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                MessageEnumWithPayload(wrappedValue: Diagnostic.LocationContext.global)
            )),
            // [3, nil]
            [0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03,  0xC0]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                MessageEnumWithPayload(wrappedValue: Diagnostic.LocationContext.task(taskID: 5, targetID: 7))
            )),
            // [0, [5, 7]]
            [0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x05,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                MessageEnumWithPayload(wrappedValue: Diagnostic.LocationContext.target(targetID: 7))
            )),
            // [1, 7]
            [0x92,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01,  0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x07]
        )
    }
}
