import Foundation

extension _MessagePackEncoder {
    final class SingleValueContainer {
        private var storage: Data = Data()
        private var canEncodeNewValue = true
        
        let codingPath: [any CodingKey]
        
        init(codingPath: [any CodingKey]) {
            self.codingPath = codingPath
        }
    }
}

extension _MessagePackEncoder.SingleValueContainer {
    fileprivate func checkAndSetCanEncode(value: Any?) throws {
        guard canEncodeNewValue else {
            let context = EncodingError.Context(
                codingPath: codingPath,
                debugDescription: """
Attempt to encode value through single value container when previously value \
already encoded.
"""
            )
            throw EncodingError.invalidValue(value as Any, context)
        }
        canEncodeNewValue = false
    }
}

// MARK: - _MessagePackEncoderContainer

extension _MessagePackEncoder.SingleValueContainer: _MessagePackEncoderContainer {
    var data: Data {
        return storage
    }
}

// MARK: - SingleValueEncodingContainer

extension _MessagePackEncoder.SingleValueContainer: SingleValueEncodingContainer {
    func encodeNil() throws {
        try checkAndSetCanEncode(value: nil)
        
        storage.append(_MessagePackEncoder.nil)
    }
    
    func encode(_ value: Bool) throws {
        try checkAndSetCanEncode(value: nil)

        storage.append(_MessagePackEncoder.bool(value))
    }

    func encode(_ value: Int) throws {
        // XCBProtocol treats `Int` as `Int64`, and doesn't do variable coding
        // based on size
        try encode(Int64(value))
    }

    func encode(_ value: UInt) throws {
        // XCBProtocol treats `UInt` as `UInt64`, and doesn't do variable coding
        // based on size
        try encode(UInt64(value))
    }
    
    func encode(_ value: Int8) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.int8(value))
    }
    
    func encode(_ value: Int16) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.int16(value))
    }
    
    func encode(_ value: Int32) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.int32(value))
    }
    
    func encode(_ value: Int64) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.int64(value))
    }
    
    func encode(_ value: UInt8) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.uint8(value))
    }
    
    func encode(_ value: UInt16) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.uint16(value))
    }
    
    func encode(_ value: UInt32) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.uint32(value))
    }
    
    func encode(_ value: UInt64) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.uint64(value))
    }

    func encode(_ value: Float) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.float(value))
    }

    func encode(_ value: Double) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.double(value))
    }

    func encode(_ value: String) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(
            try _MessagePackEncoder.string(value, codingPath: codingPath)
        )
    }

    func encode(_ value: Data) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(
            try _MessagePackEncoder.data(value, codingPath: codingPath)
        )
    }
    
    func encode(_ value: Date) throws {
        try checkAndSetCanEncode(value: value)

        storage.append(_MessagePackEncoder.date(value))
    }
    
    func encode(_ value: some Encodable) throws {
        switch value {
        case let data as Data:
            try encode(data)
        case let date as Date:
            try encode(date)
        default:
            try checkAndSetCanEncode(value: value)

            let encoder = _MessagePackEncoder(
                codingPath: codingPath,
                isKeyless: !(value is any ExpressibleByDictionaryLiteral)
            )
            try value.encode(to: encoder)
            storage.append(try encoder.data)
        }
    }
}
