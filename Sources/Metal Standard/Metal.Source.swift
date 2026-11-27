extension Metal {
    /// Source text: declarations in order.
    public struct Source: Sendable, Hashable {
        public var items: [Item]

        public init(_ items: [Item]) {
            self.items = items
        }
    }
}

extension Metal.Source {
    /// A declaration.
    public enum Item: Sendable, Hashable {
        case structure(Metal.Structure)
        /// An array of constants.
        case constants(Metal.Scalar, String, [Metal.Expression])
        /// A function's first line, so that it can be called before its body.
        case forward(Metal.Function)
        case function(Metal.Function)
    }

    /// The text, without the standard library's include.
    public var text: String {
        items.map { item in
            switch item {
            case .structure(let structure):
                (["struct \(structure.name) {"]
                    + structure.members.map { "    \($0.kind) \($0.name)" + ($0.count.map { "[\($0)]" } ?? "") + ($0.attribute.map { " \($0)" } ?? "") + ";" } + ["};"])
                    .joined(separator: "\n")
            case .constants(let scalar, let name, let values):
                "constant \(scalar.rawValue) \(name)[\(values.count)] = {\(values.map { $0.description }.joined(separator: ", "))};"
            case .forward(let function): function.head + ";"
            case .function(let function):
                ([function.head + " {"] + function.body.flatMap { $0.lines(1) } + ["}"]).joined(separator: "\n")
            }
        }
        .joined(separator: "\n\n") + "\n"
    }
}
