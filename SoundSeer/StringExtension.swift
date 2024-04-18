extension String {
    func prefixBefore(_ str: String) -> String {
        let components = self.components(separatedBy: str)
        if components.count > 1 {
            return components[0].trimmingCharacters(in: .whitespaces)
        } else {
            return self
        }
    }

    func truncate(length: Int) -> String {
        return self.count > length ? String(self.prefix(length - 3)) + "..." : self
    }
}
