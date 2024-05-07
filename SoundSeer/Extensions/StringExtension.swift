import AppKit

extension String {
    var fourCharCode: FourCharCode {
        return self.utf16.reduce(0, {$0 << 8 + FourCharCode($1)})
    }

    func prefixBefore(_ str: String) -> String {
        let components = self.components(separatedBy: str)
        if components.count > 1 {
            return components[0].trimmingCharacters(in: .whitespaces)
        } else {
            return self
        }
    }

    func truncate(length: Int) -> String {
        guard length >= 3 else {
            return String(repeating: ".", count: length)
        }

        return length >= self.count ? self : self.prefix(length - 3) + "..."
    }
}
