extension Metal {
    /// A function.
    public struct Function: Sendable, Hashable {
        public var role: Role
        public var result: Kind
        public var name: String
        public var parameters: [Parameter]
        public var body: [Statement]

        public init(role: Role, result: Kind, name: String, parameters: [Parameter], body: [Statement]) {
            self.role = role
            self.result = result
            self.name = name
            self.parameters = parameters
            self.body = body
        }
    }
}

extension Metal.Function {
    /// What a function is declared as, by its spelling.
    public enum Role: String, Sendable, Hashable, CaseIterable {
        case kernel = "kernel"
        case inner = "static"
        case inlined = "static __attribute__((always_inline))"
        case inline = "static inline"
    }

    /// A parameter, with its attribute when it has one.
    public struct Parameter: Sendable, Hashable {
        public var kind: Metal.Kind
        public var name: String
        public var attribute: Attribute?

        public init(_ kind: Metal.Kind, _ name: String, _ attribute: Attribute? = nil) {
            self.kind = kind
            self.name = name
            self.attribute = attribute
        }
    }

    /// Where a kernel's parameter comes from.
    public enum Attribute: Sendable, Hashable {
        case buffer(Int)
        case texture(Int)
        case threadPositionInGrid
        case threadIndexInSimdgroup
        case threadsPerSimdgroup
    }

    /// The first line, without the body.
    var head: String {
        let list = parameters.map { parameter in
            let attribute =
                switch parameter.attribute {
                case .buffer(let index): " [[buffer(\(index))]]"
                case .texture(let index): " [[texture(\(index))]]"
                case .threadPositionInGrid: " [[thread_position_in_grid]]"
                case .threadIndexInSimdgroup: " [[thread_index_in_simdgroup]]"
                case .threadsPerSimdgroup: " [[threads_per_simdgroup]]"
                case nil: ""
                }
            return "\(parameter.kind) \(parameter.name)\(attribute)"
        }
        return "\(role.rawValue) \(result) \(name)(\(list.joined(separator: ", ")))"
    }
}
