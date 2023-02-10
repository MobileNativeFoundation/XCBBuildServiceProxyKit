import Foundation

extension _MessagePackEncoder {
    final class KeyedContainer<Key: CodingKey> {
        private var storage: [AnyCodingKey: any _MessagePackEncoderContainer] =
            [:]

        var codingPath: [any CodingKey]
        
        init(codingPath: [any CodingKey]) {
            self.codingPath = codingPath
        }
    }
}

extension _MessagePackEncoder.KeyedContainer {
    fileprivate func nestedCodingPath(
        forKey key: any CodingKey
    ) -> [any CodingKey] {
        return codingPath + [key]
    }
}

// MARK: - _MessagePackEncoderContainer

extension _MessagePackEncoder.KeyedContainer: _MessagePackEncoderContainer {
    var data: Data {
        get throws {
            var data = Data()
            
            let length = storage.count
            if let uint16 = UInt16(exactly: length) {
                if uint16 <= 15 {
                    data.append(0x80 + UInt8(uint16))
                } else {
                    data.append(0xde)
                    data.append(contentsOf: uint16.bigEndianBytes)
                }
            } else if let uint32 = UInt32(exactly: length) {
                data.append(0xdf)
                data.append(contentsOf: uint32.bigEndianBytes)
            } else {
                fatalError()
            }
            
            for (key, container) in self.storage {
                // FIXME: Use direct packing method
                let keyContainer = _MessagePackEncoder.SingleValueContainer(
                    codingPath: self.codingPath
                )
                if let intValue = key.intValue {
                    try! keyContainer.encode(intValue)
                } else {
                    try! keyContainer.encode(key.stringValue)
                }
                data.append(keyContainer.data)
                
                data.append(try container.data)
            }
            
            return data
        }
    }
}

// MARK: - KeyedEncodingContainerProtocol

extension _MessagePackEncoder.KeyedContainer: KeyedEncodingContainerProtocol {
    func encodeNil(forKey key: Key) throws {
        var container = nestedSingleValueContainer(forKey: key)
        try container.encodeNil()
    }
    
    func encode(_ value: some Encodable, forKey key: Key) throws {
        var container = nestedSingleValueContainer(forKey: key)
        try container.encode(value)
    }
    
    private func nestedSingleValueContainer(
        forKey key: Key
    ) -> SingleValueEncodingContainer {
        let container = _MessagePackEncoder.SingleValueContainer(
            codingPath: nestedCodingPath(forKey: key)
        )
        storage[AnyCodingKey(key)] = container
        return container
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let container = _MessagePackEncoder.UnkeyedContainer(
            codingPath: nestedCodingPath(forKey: key)
        )
        storage[AnyCodingKey(key)] = container
        return container
    }
    
    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type, forKey key: Key
    ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        let container = _MessagePackEncoder.KeyedContainer<NestedKey>(
            codingPath: nestedCodingPath(forKey: key)
        )
        storage[AnyCodingKey(key)] = container
        return KeyedEncodingContainer(container)
    }
    
    func superEncoder() -> Encoder {
        fatalError("Unimplemented")
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        fatalError("Unimplemented")
    }
}
