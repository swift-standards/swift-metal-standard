extension Metal {
    /// A structure.
    public struct Structure: Sendable, Hashable {
        public var name: String
        public var members: [Member]

        public init(name: String, members: [Member]) {
            self.name = name
            self.members = members
        }
    }
}

extension Metal.Structure {
    /// A member, and how many of it when it is an array.
    public struct Member: Sendable, Hashable {
        public var kind: Metal.Kind
        public var name: String
        public var count: Int?
        /// What the member is where one stage hands the structure to the next.
        public var attribute: Attribute?

        public init(_ kind: Metal.Kind, _ name: String, count: Int? = nil, at attribute: Attribute? = nil) {
            self.kind = kind
            self.name = name
            self.count = count
            self.attribute = attribute
        }
    }

    /// What a member is where one stage hands the structure to the next.
    public enum Attribute: Sendable, Hashable {
        /// The vertex's position.
        case position
        /// A value at a numbered place, not interpolated where `flat`.
        case place(Int, flat: Bool = false)
    }
}

extension Metal.Structure.Attribute: CustomStringConvertible {
    public var description: String {
        switch self {
        case .position: "[[position]]"
        case .place(let place, let flat): "[[user(locn\(place))" + (flat ? ", flat]]" : "]]")
        }
    }
}
