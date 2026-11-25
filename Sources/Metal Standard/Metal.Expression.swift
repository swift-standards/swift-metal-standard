extension Metal {
    /// An expression.
    public indirect enum Expression: Sendable, Hashable {
        case name(String)
        case bool(Bool)
        case uint(UInt32)
        case ulong(UInt64)
        /// A `float` by its bit pattern.
        case float(UInt32)
        case call(String, [Self])
        /// A conversion, or a construction of a vector.
        case convert(Kind, [Self])
        /// The same bits as another type.
        case bits(Kind, Self)
        case member(Self, String)
        case element(Self, Self)
        case unary(Unary, Self)
        case binary(Self, Binary, Self)
        case conditional(Self, Self, Self)
    }
}

extension Metal.Expression {
    /// A prefix operator, by its spelling.
    public enum Unary: String, Sendable, Hashable, CaseIterable {
        case minus = "-"
        case complement = "~"
        case not = "!"
    }

    /// An infix operator, by its spelling.
    public enum Binary: String, Sendable, Hashable, CaseIterable {
        case plus = "+"
        case minus = "-"
        case times = "*"
        case over = "/"
        case remainder = "%"
        case and = "&"
        case or = "|"
        case xor = "^"
        case left = "<<"
        case right = ">>"
        case equal = "=="
        case unequal = "!="
        case less = "<"
        case greater = ">"
        case atMost = "<="
        case atLeast = ">="
        case both = "&&"
        case either = "||"
    }
}

extension Metal.Expression: CustomStringConvertible {
    public var description: String {
        switch self {
        case .name(let name): name
        case .bool(let value): value ? "true" : "false"
        case .uint(let value): "\(value)u"
        case .ulong(let value): "\(value)ul"
        case .float(let bits): "as_type<float>(\(bits)u)"
        case .call(let name, let arguments): "\(name)(\(Self.list(arguments)))"
        case .convert(let kind, let arguments): "\(kind)(\(Self.list(arguments)))"
        case .bits(let kind, let value): "as_type<\(kind)>(\(value))"
        case .member(let value, let name): "\(value.operand).\(name)"
        case .element(let value, let place): "\(value.operand)[\(place)]"
        case .unary(let sign, let value): "\(sign.rawValue)\(value.operand)"
        case .binary(let first, let sign, let second): "\(first.operand) \(sign.rawValue) \(second.operand)"
        case .conditional(let condition, let first, let second): "\(condition.operand) ? \(first.operand) : \(second.operand)"
        }
    }

    private static func list(_ expressions: [Self]) -> String {
        expressions.map { $0.description }.joined(separator: ", ")
    }

    /// The text as an operand: in parentheses when it is compound.
    private var operand: String {
        switch self {
        case .unary, .binary, .conditional: "(\(self))"
        default: description
        }
    }
}
