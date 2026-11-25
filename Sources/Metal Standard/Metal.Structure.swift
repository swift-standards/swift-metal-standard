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

        public init(_ kind: Metal.Kind, _ name: String, count: Int? = nil) {
            self.kind = kind
            self.name = name
            self.count = count
        }
    }
}
