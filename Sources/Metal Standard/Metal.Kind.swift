extension Metal {
    /// A type.
    public indirect enum Kind: Sendable, Hashable {
        case void
        case scalar(Scalar)
        /// A vector of two to four scalars.
        case vector(Scalar, Int)
        case structure(String)
        /// A texture of two dimensions, written as vectors of a scalar.
        case texture(Scalar)
        case pointer(Kind, Space, constant: Bool = false)
        case reference(Kind, Space, constant: Bool = false)
    }
}

extension Metal.Kind {
    public static let int = Self.scalar(.int)
    public static let uint = Self.scalar(.uint)
    public static let long = Self.scalar(.long)
    public static let ulong = Self.scalar(.ulong)
    public static let float = Self.scalar(.float)
}

extension Metal.Kind: CustomStringConvertible {
    public var description: String {
        switch self {
        case .void: "void"
        case .scalar(let scalar): scalar.rawValue
        case .vector(let scalar, let count): "\(scalar.rawValue)\(count)"
        case .structure(let name): name
        case .texture(let scalar): "texture2d<\(scalar.rawValue), access::write>"
        case .pointer(let kind, let space, let constant): "\(space.rawValue) \(constant ? "const " : "")\(kind) *"
        case .reference(let kind, let space, let constant): "\(space.rawValue) \(constant ? "const " : "")\(kind) &"
        }
    }
}
