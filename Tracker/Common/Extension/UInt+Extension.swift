
extension Int {
    func days() -> String {
        var daysStrung = ""
        let str = String(self)
        if .las == "1" {
            daysStrung = "день"
        }
        return daysStrung
    }
}
