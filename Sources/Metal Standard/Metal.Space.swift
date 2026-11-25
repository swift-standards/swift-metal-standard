extension Metal {
    /// An address space, by its name in the language.
    public enum Space: String, Sendable, Hashable, CaseIterable {
        case device
        case constant
        case thread
        case threadgroup
    }
}
