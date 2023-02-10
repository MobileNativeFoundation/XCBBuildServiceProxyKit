import CustomDump
import XCTest

@testable import XCBProtocol

class MessagePackEncoderTests: XCTestCase {
    let encoder = MessagePackEncoder()

    let bytes15 = [UInt8](1...15)
    let bytes16 = [UInt8](0...15)
    let bytes31 = [UInt8](1...31)
    let bytes32 = [UInt8](0...31)
    let bytes255 = [UInt8](1...255)
    let bytes256 = [UInt8](0...255)
    let bytes65535 = (1...65_535).map { $0.bigEndianBytes[0] }
    let bytes65536 = (0...65_535).map { $0.bigEndianBytes[0] }
    let letters = "abcdefghijklmnopqrstuvwxyz"

    // MARK: - nil
    
    func test_encode_nil() throws {
        // MARK: nil

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.nil),
            [0xc0]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(nil as Int?)),
            [UInt8](_MessagePackEncoder.nil)
        )
    }

    // MARK: - Bool
    
    func test_encode_Bool() throws {

        // MARK: false

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.bool(false)),
            [0xc2]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(false)),
            [UInt8](_MessagePackEncoder.bool(false))
        )

        // MARK: true

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.bool(true)),
            [0xc3]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(true)),
            [UInt8](_MessagePackEncoder.bool(true))
        )
    }

    // MARK: - Int

    func test_encode_Int() throws {
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(42 as Int)),
            [UInt8](try encoder.encode(42 as Int64))
        )
    }

    // MARK: - UInt

    func test_encode_UInt() throws {
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(128 as UInt)),
            [UInt8](try encoder.encode(128 as UInt64))
        )
    }

    // MARK: - Signed fixed size integers

    func test_encode_Int8() throws {

        // MARK: positive fixint

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int8(0)),
            [0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(0 as Int8)),
            [UInt8](_MessagePackEncoder.int8(0))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int8(42)),
            [0x2A]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(42 as Int8)),
            [UInt8](_MessagePackEncoder.int8(42))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int8(127)),
            [0x7F]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(127 as Int8)),
            [UInt8](_MessagePackEncoder.int8(127))
        )

        // MARK: negative fixint

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int8(-1)),
            [0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(-1 as Int8)),
            [UInt8](_MessagePackEncoder.int8(-1))
        )

        // MARK: int 8

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int8(-128)),
            [0xD0] + [0x80]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(-128 as Int8)),
            [UInt8](_MessagePackEncoder.int8(-128))
        )
    }

    func test_encode_Int16() throws {

        // MARK: int 16

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int16(0)),
            [0xD1] + [0x00, 0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(0 as Int16)),
            [UInt8](_MessagePackEncoder.int16(0))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int16(-1)),
            [0xD1] + [0xFF, 0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(-1 as Int16)),
            [UInt8](_MessagePackEncoder.int16(-1))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int16(24_666)),
            [0xD1] + [0x60, 0x5A]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(24_666 as Int16)),
            [UInt8](_MessagePackEncoder.int16(24_666))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int16(-32_768)),
            [0xD1] + [0x80, 00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(-32_768 as Int16)),
            [UInt8](_MessagePackEncoder.int16(-32_768))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int16(32_767)),
            [0xD1] + [0x7F, 0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(32_767 as Int16)),
            [UInt8](_MessagePackEncoder.int16(32_767))
        )
    }

    func test_encode_Int32() throws {

        // MARK: int 32

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int32(0)),
            [0xD2] + [0x00, 0x00, 0x00, 0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(0 as Int32)),
            [UInt8](_MessagePackEncoder.int32(0))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int32(-1)),
            [0xD2] + [0xFF, 0xFF, 0xFF, 0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(-1 as Int32)),
            [UInt8](_MessagePackEncoder.int32(-1))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int32(1_147_483_647)),
            [0xD2] + [0x44, 0x65, 0x35, 0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(1_147_483_647 as Int32)),
            [UInt8](_MessagePackEncoder.int32(1_147_483_647))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int32(-2_147_483_648)),
            [0xD2] + [0x80, 0x00, 0x00, 0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(-2_147_483_648 as Int32)),
            [UInt8](_MessagePackEncoder.int32(-2_147_483_648))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int32(2_147_483_647)),
            [0xD2] + [0x7F, 0xFF, 0xFF, 0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(2_147_483_647 as Int32)),
            [UInt8](_MessagePackEncoder.int32(2_147_483_647))
        )
    }

    func test_encode_Int64() throws {

        // MARK: int 64

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int64(0)),
            [0xD3] + [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(0 as Int64)),
            [UInt8](_MessagePackEncoder.int64(0))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int64(-1)),
            [0xD3] + [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(-1 as Int64)),
            [UInt8](_MessagePackEncoder.int64(-1))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int64(1_223_372_136_854_775_806)),
            [0xD3] + [0x10, 0xFA, 0x4A, 0x7A, 0x0D, 0x56, 0xE7, 0xFE]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(1_223_372_136_854_775_806 as Int64)),
            [UInt8](_MessagePackEncoder.int64(1_223_372_136_854_775_806))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int64(-9_223_372_036_854_775_808)),
            [0xD3] + [0x80, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(-9_223_372_036_854_775_808 as Int64)),
            [UInt8](_MessagePackEncoder.int64(-9_223_372_036_854_775_808))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.int64(9_223_372_036_854_775_807)),
            [0xD3] + [0x7F, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(9_223_372_036_854_775_807 as Int64)),
            [UInt8](_MessagePackEncoder.int64(9_223_372_036_854_775_807))
        )
    }

    // MARK: - Unsigned fixed size integers

    func test_encode_UInt8() throws {

        // MARK: positive fixint

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint8(0)),
            [0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(0 as UInt8)),
            [UInt8](_MessagePackEncoder.uint8(0))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint8(127)),
            [0x7F]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(127 as UInt8)),
            [UInt8](_MessagePackEncoder.uint8(127))
        )

        // MARK: unit 8

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint8(128)),
            [0xCC] + [0x80]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(128 as UInt8)),
            [UInt8](_MessagePackEncoder.uint8(128))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint8(255)),
            [0xCC] + [0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(255 as UInt8)),
            [UInt8](_MessagePackEncoder.uint8(255))
        )
    }

    func test_encode_UInt16() throws {

        // MARK: unit 16

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint16(0)),
            [0xCD] + [0x00, 0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(0 as UInt16)),
            [UInt8](_MessagePackEncoder.uint16(0))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint16(13_534)),
            [0xCD] + [0x34, 0xDE]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(13_534 as UInt16)),
            [UInt8](_MessagePackEncoder.uint16(13_534))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint16(65_535)),
            [0xCD] + [0xFF, 0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(65_535 as UInt16)),
            [UInt8](_MessagePackEncoder.uint16(65_535))
        )
    }

    func test_encode_UInt32() throws {

        // MARK: unit 32

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint32(0)),
            [0xCE] + [0x00, 0x00, 0x00, 0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(0 as UInt32)),
            [UInt8](_MessagePackEncoder.uint32(0))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint32(1_224_967_255)),
            [0xCE] + [0x49, 0x03, 0x84, 0x57]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(1_224_967_255 as UInt32)),
            [UInt8](_MessagePackEncoder.uint32(1_224_967_255))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint32(4_294_967_295)),
            [0xCE] + [0xFF, 0xFF, 0xFF, 0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(4_294_967_295 as UInt32)),
            [UInt8](_MessagePackEncoder.uint32(4_294_967_295))
        )
    }

    func test_encode_UInt64() throws {

        // MARK: unit 64

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint64(0)),
            [0xCF] + [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(0 as UInt64)),
            [UInt8](_MessagePackEncoder.uint64(0))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint64(1_446_744_073_708_551_613)),
            [0xCF] + [0x14, 0x13, 0xDE, 0x11, 0xE2, 0x4C, 0xBD, 0xBD]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(1_446_744_073_708_551_613 as UInt64)),
            [UInt8](_MessagePackEncoder.uint64(1_446_744_073_708_551_613))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.uint64(18_446_744_073_709_551_615)),
            [0xCF] + [0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(18_446_744_073_709_551_615 as UInt64)),
            [UInt8](_MessagePackEncoder.uint64(18_446_744_073_709_551_615))
        )
    }

    // MARK: - Float

    func test_encode_Float() throws {

        // MARK: float 32

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.float(3.14)),
            [0xCA] + [0x40, 0x48, 0xF5, 0xC3]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(3.14 as Float)),
            [UInt8](_MessagePackEncoder.float(3.14))
        )
    }

    // MARK: - Double

    func test_encode_Double() throws {

        // MARK: float 64

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.double(3.14159)),
            [0xCB] + [0x40, 0x09, 0x21, 0xF9, 0xF0, 0x1B, 0x86, 0x6E]
        )

        XCTAssertNoDifference(
            [UInt8](try encoder.encode(3.14159 as Double)),
            [UInt8](_MessagePackEncoder.double(3.14159))
        )
    }

    // MARK: - String
    
    func test_encode_String() throws {
        // MARK: fixstr

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.string("")),
            [0xA0]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode("")),
            [UInt8](try _MessagePackEncoder.string(""))
        )

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.string("hello")),
            [0xA5] + [0x68, 0x65, 0x6C, 0x6C, 0x6F]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode("hello")),
            [UInt8](try _MessagePackEncoder.string("hello"))
        )

        // MARK: str 8

        // FIXME: add str 8 test

        // MARK: str 16

        // FIXME: add str 16 test

        // MARK: str 32

        // FIXME: add str 32 test
    }

    // MARK: - Data

    func test_encode_Data() throws {
        // MARK: bin 8

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.data(Data())),
            [0xC4] + [0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(Data())),
            [UInt8](try _MessagePackEncoder.data(Data()))
        )

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.data(
                Data([0x68, 0x65, 0x6C, 0x6C, 0x6F])
            )),
            [0xC4] + [0x05] + [0x68, 0x65, 0x6C, 0x6C, 0x6F]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(Data([0x68, 0x65, 0x6C, 0x6C, 0x6F]))),
            [UInt8](try _MessagePackEncoder.data(
                Data([0x68, 0x65, 0x6C, 0x6C, 0x6F])
            ))
        )

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.data(Data(bytes255))),
            [0xC4] + [0xFF] + bytes255
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(Data(bytes255))),
            [UInt8](try _MessagePackEncoder.data(Data(bytes255)))
        )

        // MARK: bin 16

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.data(Data(bytes256))),
            [0xC5] + [0x01, 0x00] + bytes256
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(Data(bytes256))),
            [UInt8](try _MessagePackEncoder.data(Data(bytes256)))
        )

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.data(Data(bytes65535))),
            [0xC5] + [0xFF, 0xFF] + bytes65535
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(Data(bytes65535))),
            [UInt8](try _MessagePackEncoder.data(Data(bytes65535)))
        )

        // MARK: bin 32

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.data(Data(bytes65536))),
            [0xC6] + [0x00, 0x01, 0x00, 0x00] + bytes65536
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(Data(bytes65536))),
            [UInt8](try _MessagePackEncoder.data(Data(bytes65536)))
        )
    }

    // MARK: - Array

    func test_encode_Array() throws {
        // MARK: fixarray

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.array([])),
            [0x90]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode([UInt8]())),
            [UInt8](try _MessagePackEncoder.array([]))
        )

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.array(bytes15.map { Data([$0]) })),
            [0x9F] + bytes15
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(bytes15)),
            [UInt8](try _MessagePackEncoder.array(bytes15.map { Data([$0]) }))
        )

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.array([
                _MessagePackEncoder.string("hello"),
                _MessagePackEncoder.string("world!"),
            ])),
            [UInt8](
                try Data([0x92]) +
                _MessagePackEncoder.string("hello") +
                _MessagePackEncoder.string("world!")
            )
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(["hello", "world!"])),
            [UInt8](try _MessagePackEncoder.array([
                _MessagePackEncoder.string("hello"),
                _MessagePackEncoder.string("world!"),
            ]))
        )

        // MARK: array 16

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.array(bytes16.map { Data([$0]) })),
            [0xDC] + [0x00, 0x10] + bytes16
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(bytes16)),
            [UInt8](try _MessagePackEncoder.array(bytes16.map { Data([$0]) }))
        )

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.array(
                bytes65535.map { Data([$0]) }
            )),
            [0xDC] + [0xFF, 0xFF] + bytes65535
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(bytes65535)),
            [UInt8](try _MessagePackEncoder.array(
                bytes65535.map { Data([$0]) }
            ))
        )

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.array(
                "hello world! msgpack".map {
                    try _MessagePackEncoder.string(String($0))
                }
            )),
            [UInt8](
                try Data([0xDC,  0x00, 0x14]) +
                "hello world! msgpack"
                    .reduce(into: Data()) { data, character in
                        data.append(
                            try _MessagePackEncoder.string(String(character))
                        )
                    }
            )
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                "hello world! msgpack".map { String($0) }
            )),
            [UInt8](try _MessagePackEncoder.array(
                "hello world! msgpack".map {
                    try _MessagePackEncoder.string(String($0))
                }
            ))
        )

        // MARK: array 32

        XCTAssertNoDifference(
            [UInt8](try _MessagePackEncoder.array(
                bytes65536.map { Data([$0]) }
            )),
            [0xDD] + [0x00, 0x01, 0x00, 0x00] + bytes65536
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(bytes65536)),
            [UInt8](try _MessagePackEncoder.array(
                bytes65536.map { Data([$0]) }
            ))
        )
    }

    // MARK: - Dictionary
    
    func test_encode_Dictionary() throws {
        // MARK: fixmap

        XCTAssertNoDifference(
            [UInt8](try encoder.encode([String: UInt8]())),
            [0x80]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(["a": bytes15])),
            [0x81] + [0xA1, 0x61] + [0x9F] + bytes15
        )

        let encoded15 = try encoder.encode([String: UInt8](
            uniqueKeysWithValues: zip(
                letters.map { String($0) }.prefix(upTo: 15),
                1...15
            )
        ))
        XCTAssertEqual(encoded15.count, 1 + 15 * 3)
        XCTAssert(encoded15.starts(with: [0x8F]))

        // MARK: map 16

        let dictionary16 = [String: UInt8](
            uniqueKeysWithValues: zip(
                letters.map { String($0) }.prefix(upTo: 16),
                0...16
            )
        )
        let encoded16 = try encoder.encode(dictionary16)
        XCTAssertEqual(encoded16.count, 1 + 2 + 16 * 3)
        XCTAssert(encoded16.starts(with: [0xDE] + [0x00, 0x10]))

        let dictionary65535 = [Int: UInt8](
            uniqueKeysWithValues: zip(
                1...65_535,
                bytes65535
            )
        )
        let encoded65535 = try encoder.encode(dictionary65535)
        XCTAssertEqual(encoded65535.count, 1 + 2 + 65_535 * 10)
        XCTAssert(encoded65535.starts(with: [0xDE] + [0xFF, 0xFF]))

        // MARK: map 32

        let dictionary65536 = [Int: UInt8](
            uniqueKeysWithValues: zip(
                0...65_535,
                bytes65536
            )
        )
        let encoded65536 = try encoder.encode(dictionary65536)
        XCTAssertEqual(encoded65536.count, 1 + 4 + 65_536 * 10)
        XCTAssert(encoded65536.starts(with: [0xDF] + [0x00, 0x01, 0x00, 0x00]))
    }

    // MARK: - Date

    func test_encode_Date() throws {
        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.date(Date(timeIntervalSince1970: 1))),
            [0xD6] + [0xFF] + [0x00, 0x00, 0x00, 0x01]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(Date(timeIntervalSince1970: 1))),
            [UInt8](_MessagePackEncoder.date(Date(timeIntervalSince1970: 1)))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.date(Date.distantPast)),
            [0xC7] + [0x0C] + [0xFF] + [0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF, 0xFF, 0xF1, 0x88, 0x6B, 0x66, 0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(Date.distantPast)),
            [UInt8](_MessagePackEncoder.date(Date.distantPast))
        )

        XCTAssertNoDifference(
            [UInt8](_MessagePackEncoder.date(Date.distantFuture)),
            [0xC7] + [0x0C] + [0xFF] + [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0E, 0xEC, 0x31, 0x88, 0x00]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(Date.distantFuture)),
            [UInt8](_MessagePackEncoder.date(Date.distantFuture))
        )
    }

    // MARK: - Other "Keyed" Encodable

    // We want these to be encoded as arrays instead of maps
    func test_encodeNonDictionaryKeyedEncodable() throws {
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                BuildCancelRequest(sessionHandle: "Bob", id: 42)
            )),
            // ["Bob", Int(42)]
            [0x92] + [0xA3, 0x42, 0x6F, 0x62] + [0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2A]
        )
        XCTAssertNoDifference(
            [UInt8](try encoder.encode(
                IPCMessage(
                    message: BuildCancelRequest(sessionHandle: "Bob", id: 42)
                )
            )),
            // ["BUILD_CANCEL", ["Bob", Int(42)]]
            [0x92] + [0xAC, 0x42, 0x55, 0x49, 0x4C, 0x44, 0x5F, 0x43, 0x41, 0x4E, 0x43, 0x45, 0x4C] + [0x92] + [0xA3, 0x42, 0x6F, 0x62] + [0xD3, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x2A]
        )
    }
}
