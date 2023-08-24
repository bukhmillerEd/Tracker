
extension UInt {
    func days() -> String {
        let secondDigitFromEnd = (self / 10) % 10
        let lastDigit = self % 10
        if secondDigitFromEnd == 1 || 5...9 ~= lastDigit || lastDigit == 0 {
            return "дней"
        } else if lastDigit == 1 {
            return "день"
        } else if 2...4 ~= lastDigit   {
            return "дня"
        }
        return ""
    }
}

