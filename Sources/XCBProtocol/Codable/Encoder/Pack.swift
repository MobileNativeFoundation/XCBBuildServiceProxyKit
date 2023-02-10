import Foundation

extension _MessagePackEncoder {
    static var `nil`: Data {
        return Data([0xc0])
    }

    static func bool(_ value: Bool) -> Data {
        if value {
            return Data([0xc3])
        } else {
            return Data([0xc2])
        }
    }

    static func int8(_ value: Int8) -> Data {

        if (value >= 0 && value <= 127) {
            // positive fixint
            return Data([UInt8(value)])
        } else if (value < 0 && value >= -31) {
            // negative fixint
            return Data([0xe0 + (0x1f & UInt8(truncatingIfNeeded: value))])
        } else {
            // int 8
            var data = Data()

            data.append(0xd0)
            data.append(contentsOf: value.bigEndianBytes)

            return data
        }
    }

    static func int16(_ value: Int16) -> Data {
        var data = Data()

        data.append(0xd1)
        data.append(contentsOf: value.bigEndianBytes)

        return data
    }

    static func int32(_ value: Int32) -> Data {
        var data = Data()

        data.append(0xd2)
        data.append(contentsOf: value.bigEndianBytes)

        return data
    }

    static func int64(_ value: Int64) -> Data {
        var data = Data()

        data.append(0xd3)
        data.append(contentsOf: value.bigEndianBytes)

        return data
    }

    static func uint8(_ value: UInt8) -> Data {
        if (value <= 127) {
            // positive fixint
            return Data([value])
        } else {
            // uint 8
            var data = Data()

            data.append(0xcc)
            data.append(contentsOf: value.bigEndianBytes)

            return data
        }
    }

    static func uint16(_ value: UInt16) -> Data {
        var data = Data()

        data.append(0xcd)
        data.append(contentsOf: value.bigEndianBytes)

        return data
    }

    static func uint32(_ value: UInt32) -> Data {
        var data = Data()

        data.append(0xce)
        data.append(contentsOf: value.bigEndianBytes)

        return data
    }

    static func uint64(_ value: UInt64) -> Data {
        var data = Data()

        data.append(0xcf)
        data.append(contentsOf: value.bigEndianBytes)

        return data
    }

    static func float(_ value: Float) -> Data {
        var data = Data()

        data.append(0xca)
        data.append(contentsOf: value.bitPattern.bigEndianBytes)

        return data
    }

    static func double(_ value: Double) -> Data {
        var data = Data()

        data.append(0xcb)
        data.append(contentsOf: value.bitPattern.bigEndianBytes)

        return data
    }

    static func string(_ value: String, codingPath: [CodingKey] = []) throws -> Data {
        guard let utf8 = value.data(using: .utf8) else {
            let context = EncodingError.Context(
                codingPath: codingPath,
                debugDescription: """
Failed to encode string using UTF-8 encoding.
"""
            )
            throw EncodingError.invalidValue(value, context)
        }

        var data = Data()

        let length = utf8.count
        if let uint8 = UInt8(exactly: length) {
            if (uint8 <= 31) {
                // fixstr
                data.append(0xa0 + uint8)
            } else {
                // str 8
                data.append(0xd9)
                data.append(contentsOf: uint8.bigEndianBytes)
            }
        } else if let uint16 = UInt16(exactly: length) {
            // str 16
            data.append(0xda)
            data.append(contentsOf: uint16.bigEndianBytes)
        } else if let uint32 = UInt32(exactly: length) {
            // str 32
            data.append(0xdb)
            data.append(contentsOf: uint32.bigEndianBytes)
        } else {
            let context = EncodingError.Context(
                codingPath: codingPath,
                debugDescription: "Cannot encode string with length \(length)."
            )
            throw EncodingError.invalidValue(value, context)
        }

        data.append(utf8)

        return data
    }

    static func data(_ value: Data, codingPath: [CodingKey] = []) throws -> Data {
        var data = Data()

        let length = value.count
        if let uint8 = UInt8(exactly: length) {
            // bin 8
            data.append(0xc4)
            data.append(uint8)
            data.append(value)
        } else if let uint16 = UInt16(exactly: length) {
            // bin 16
            data.append(0xc5)
            data.append(contentsOf: uint16.bigEndianBytes)
            data.append(value)
        } else if let uint32 = UInt32(exactly: length) {
            // bin 32
            data.append(0xc6)
            data.append(contentsOf: uint32.bigEndianBytes)
            data.append(value)
        } else {
            let context = EncodingError.Context(
                codingPath: codingPath,
                debugDescription: "Cannot encode data of length \(value.count)."
            )
            throw EncodingError.invalidValue(value, context)
        }

        return data
    }

    static func array(_ values: [Data], codingPath: [CodingKey] = []) throws -> Data {
        var data = Data()

        let length = values.count
        if let uint16 = UInt16(exactly: length) {
            if uint16 <= 15 {
                data.append(0x90 + UInt8(uint16))
            } else {
                data.append(0xdc)
                data.append(contentsOf: uint16.bigEndianBytes)
            }
        } else if let uint32 = UInt32(exactly: length) {
            data.append(0xdd)
            data.append(contentsOf: uint32.bigEndianBytes)
        } else {
            let context = EncodingError.Context(
                codingPath: codingPath,
                debugDescription: """
Cannot encode array of length \(values.count).
"""
            )
            throw EncodingError.invalidValue(values, context)
        }

        for value in values {
            data.append(value)
        }

        return data
    }

    static func date(_ value: Date) -> Data {
        let timeInterval = value.timeIntervalSince1970
        let (integral, fractional) = modf(timeInterval)

        let seconds = Int64(integral)
        let nanoseconds = UInt32(fractional * Double(NSEC_PER_SEC))

        var data = Data()

        if seconds < 0 || seconds > UInt32.max {
            // timestamp 96
            data.append(0xc7)
            data.append(0x0C)
            data.append(0xFF)
            data.append(contentsOf: nanoseconds.bigEndianBytes)
            data.append(contentsOf: seconds.bigEndianBytes)
        } else if nanoseconds > 0 {
            // timestamp 64
            data.append(0xd7)
            data.append(0xFF)
            data.append(
                contentsOf: ((UInt64(nanoseconds) << 34) + UInt64(seconds))
                    .bigEndianBytes
            )
        } else {
            // timestamp 32
            data.append(0xd6)
            data.append(0xFF)
            data.append(contentsOf: UInt32(seconds).bigEndianBytes)
        }

        return data
    }
}
