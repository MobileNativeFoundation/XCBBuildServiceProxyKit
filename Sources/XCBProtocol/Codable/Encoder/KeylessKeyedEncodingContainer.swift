import Foundation

extension _MessagePackEncoder {
    final class KeylessKeyedContainer<Key: CodingKey> {
        private var storage: [any _MessagePackEncoderContainer] = []

        var codingPath: [any CodingKey]
        
        init(codingPath: [any CodingKey]) {
            self.codingPath = codingPath
        }
    }
}

extension _MessagePackEncoder.KeylessKeyedContainer {
    fileprivate func nestedCodingPath(
        forKey key: any CodingKey
    ) -> [any CodingKey] {
        return codingPath + [key]
    }
}

// MARK: - _MessagePackEncoderContainer

extension _MessagePackEncoder.KeylessKeyedContainer: _MessagePackEncoderContainer {
    var data: Data {
        get throws {
            return try _MessagePackEncoder.array(
                storage.map { try $0.data },
                codingPath: codingPath
            )
        }
    }
}

// MARK: - KeyedEncodingContainerProtocol

extension _MessagePackEncoder.KeylessKeyedContainer: KeyedEncodingContainerProtocol {
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
        storage.append(container)
        return container
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        let container = _MessagePackEncoder.UnkeyedContainer(
            codingPath: nestedCodingPath(forKey: key)
        )
        storage.append(container)
        return container
    }
    
    func nestedContainer<NestedKey>(
        keyedBy keyType: NestedKey.Type, forKey key: Key
    ) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        // FIXME: Determine if we should do this conditionally
        let container = _MessagePackEncoder.KeylessKeyedContainer<NestedKey>(
            codingPath: nestedCodingPath(forKey: key)
        )
        storage.append(container)
        return KeyedEncodingContainer(container)
    }
    
    func superEncoder() -> Encoder {
        fatalError("Unimplemented")
    }
    
    func superEncoder(forKey key: Key) -> Encoder {
        fatalError("Unimplemented")
    }
}
