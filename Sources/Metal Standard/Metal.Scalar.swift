extension Metal {
    /// A scalar type, by its name in the language.
    public enum Scalar: String, Sendable, Hashable, CaseIterable {
        case bool
        case char
        case uchar
        case short
        case ushort
        case int
        case uint
        case long
        case ulong
        case half
        case float
    }
}
