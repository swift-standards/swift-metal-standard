extension Metal {
    /// A statement.
    public indirect enum Statement: Sendable, Hashable {
        case declare(Kind, String, Expression?)
        /// An array of a number of elements.
        case array(Kind, String, Int)
        case assign(Expression, Expression)
        case evaluate(Expression)
        case `if`(Expression, [Self], else: [Self] = [])
        case `while`(Expression, [Self])
        /// A block that runs once, and that `break` leaves.
        case once([Self])
        case `break`
        case `continue`
        case `return`(Expression?)
        /// A `#pragma METAL` at the start of a block.
        case pragma(String)
    }
}

extension Metal.Statement {
    /// The statement's lines, each indented by `depth` steps.
    func lines(_ depth: Int) -> [String] {
        let indent = String(repeating: "    ", count: depth)
        func inner(_ statements: [Self]) -> [String] { statements.flatMap { $0.lines(depth + 1) } }
        switch self {
        case .declare(let kind, let name, let value): return [indent + "\(kind) \(name)" + (value.map { " = \($0)" } ?? "") + ";"]
        case .array(let kind, let name, let count): return [indent + "\(kind) \(name)[\(count)];"]
        case .assign(let place, let value): return [indent + "\(place) = \(value);"]
        case .evaluate(let value): return [indent + "\(value);"]
        case .if(let condition, let then, let otherwise):
            let tail = otherwise.isEmpty ? [indent + "}"] : [indent + "} else {"] + inner(otherwise) + [indent + "}"]
            return [indent + "if (\(condition)) {"] + inner(then) + tail
        case .while(let condition, let body): return [indent + "while (\(condition)) {"] + inner(body) + [indent + "}"]
        case .once(let body): return [indent + "do {"] + inner(body) + [indent + "} while (false);"]
        case .break: return [indent + "break;"]
        case .continue: return [indent + "continue;"]
        case .return(let value): return [indent + "return" + (value.map { " \($0)" } ?? "") + ";"]
        case .pragma(let text): return [indent + "#pragma METAL \(text)"]
        }
    }
}
