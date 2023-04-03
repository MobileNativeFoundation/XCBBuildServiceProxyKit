@propertyWrapper
public struct MessageEnum<Enum: MessageEnumCodable>: Codable {
    public var wrappedValue: Enum

    public init(wrappedValue: Enum) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        fatalError("Unimplemented")
    }

    public func encode(to encoder: Encoder) throws {
        // TODO: Cache this
        let allTags = Enum.tagCases()
        var tagCount = 0
        var tagToInt: [Enum.TagEnums.Element: Int] = [:]
        for tag in allTags {
            tagToInt[tag] = tagCount
            tagCount += 1
        }

        let tag = wrappedValue.tag()

        guard let tagInt = tagToInt[tag] else {
            // TODO: Throw encoding error
            fatalError()
        }

        var container = encoder.singleValueContainer()
        try container.encode(tagInt)
    }
}

@propertyWrapper
public struct MessageEnumWithPayload<Enum: MessageEnumWithPayloadCodable>: Codable {
    public var wrappedValue: Enum

    public init(wrappedValue: Enum) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        fatalError("Unimplemented")
    }

    public func encode(to encoder: Encoder) throws {
        // TODO: Cache this
        let allTags = Enum.tagCases()
        var tagCount = 0
        var tagToInt: [Enum.TagEnums.Element: Int] = [:]
        for tag in allTags {
            tagToInt[tag] = tagCount
            tagCount += 1
        }

        let tag = wrappedValue.tag()

        guard let tagInt = tagToInt[tag] else {
            // TODO: Throw encoding error
            fatalError()
        }

        try wrappedValue.encode(tagInt: tagInt, to: encoder)
    }
}

public enum MessageEnumCodingKeys: String, CodingKey {
    case tag
}

public protocol MessageEnumCodable: Hashable, CaseIterable {
    associatedtype TagEnums: Collection where TagEnums.Element == Self

    static func tagCases() -> TagEnums
    func tag() -> Self
}

public protocol MessageEnumWithPayloadCodable {
    associatedtype TagEnums: Collection where TagEnums.Element: Hashable, TagEnums.Element: CaseIterable

    static func tagCases() -> TagEnums
    func tag() -> TagEnums.Element
    func encode(tagInt: Int, to encoder: Encoder) throws
}

// MARK: - Defaults

public extension MessageEnumCodable {
    static func tagCases() -> AllCases {
        return allCases
    }

    func tag() -> Self { self }
}


public extension MessageEnumWithPayloadCodable {
    // By default return `TagEnums.Element.allCases`, but can customize.
    static func tagCases() -> TagEnums.Element.AllCases {
        return TagEnums.Element.allCases
    }
}
