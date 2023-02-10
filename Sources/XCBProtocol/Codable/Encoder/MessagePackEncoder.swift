import Foundation

public struct MessagePackEncoder {
    public init() {}

    public func encode(_ value: some Encodable) throws -> Data {
        let encoder = _MessagePackEncoder(
            isKeyless: !(value is any ExpressibleByDictionaryLiteral)
        )

        switch value {
        case let data as Data:
            try Box<Data>(data).encode(to: encoder)
        case let date as Date:
            try Box<Date>(date).encode(to: encoder)
        default:
            try value.encode(to: encoder)
        }
        
        return try encoder.data
    }
}

// MARK: - TopLevelEncoder

#if canImport(Combine)

import Combine

extension MessagePackEncoder: TopLevelEncoder {}

#endif

// MARK: - Encoder

final class _MessagePackEncoder {
    private let isKeyless: Bool

    var codingPath: [any CodingKey]

    var container: (any _MessagePackEncoderContainer)?

    init(codingPath: [any CodingKey] = [], isKeyless: Bool = false) {
        self.codingPath = codingPath
        self.isKeyless = isKeyless
    }

    var data: Data {
        get throws {
            return try container?.data ?? Data()
        }
    }
}

protocol _MessagePackEncoderContainer {
    var data: Data { get throws }
}

extension _MessagePackEncoder: Encoder {
    private func assertCanCreateContainer() {
        precondition(self.container == nil)
    }

    var userInfo: [CodingUserInfoKey : Any] { [:] }

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key>
    where Key: CodingKey {
        assertCanCreateContainer()

        if isKeyless {
            let container = KeylessKeyedContainer<Key>(
                codingPath: self.codingPath
            )
            self.container = container
            return KeyedEncodingContainer(container)
        } else {
            let container = KeyedContainer<Key>(
                codingPath: self.codingPath
            )
            self.container = container
            return KeyedEncodingContainer(container)
        }
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        assertCanCreateContainer()
        
        let container = SingleValueContainer(codingPath: self.codingPath)
        self.container = container
        return container
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        assertCanCreateContainer()
        
        let container = UnkeyedContainer(codingPath: self.codingPath)
        self.container = container
        return container
    }
}
