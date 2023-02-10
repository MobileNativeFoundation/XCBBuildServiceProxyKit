import Foundation

extension _MessagePackEncoder {
    final class UnkeyedContainer {
        private var storage: [any _MessagePackEncoderContainer] = []
        
        var codingPath: [any CodingKey]
        
        init(codingPath: [any CodingKey]) {
            self.codingPath = codingPath
        }
    }
}

extension _MessagePackEncoder.UnkeyedContainer {
    fileprivate var nestedCodingPath: [any CodingKey] {
        return codingPath + [AnyCodingKey(intValue: count)!]
    }
}

// MARK: - _MessagePackEncoderContainer

extension _MessagePackEncoder.UnkeyedContainer: _MessagePackEncoderContainer {
    var data: Data {
        var data = Data()
        
        let length = storage.count
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
            fatalError()
        }
        
        for container in storage {
            data.append(container.data)
        }
        
        return data
    }
}

// MARK: - UnkeyedEncodingContainer

extension _MessagePackEncoder.UnkeyedContainer: UnkeyedEncodingContainer {
    var count: Int { storage.count }

    func encodeNil() throws {
        var container = nestedSingleValueContainer()
        try container.encodeNil()
    }
    
    func encode(_ value: some Encodable) throws {
        var container = nestedSingleValueContainer()
        try container.encode(value)
    }
    
    private func nestedSingleValueContainer() -> SingleValueEncodingContainer {
        let container = _MessagePackEncoder.SingleValueContainer(
            codingPath: nestedCodingPath
        )
        storage.append(container)

        return container
    }
    
    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        let container = _MessagePackEncoder.KeyedContainer<NestedKey>(
            codingPath: nestedCodingPath
        )
        storage.append(container)
        return KeyedEncodingContainer(container)
    }
    
    func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = _MessagePackEncoder.UnkeyedContainer(
            codingPath: nestedCodingPath
        )
        storage.append(container)
        return container
    }
    
    func superEncoder() -> Encoder {
        fatalError("Unimplemented")
    }
}
