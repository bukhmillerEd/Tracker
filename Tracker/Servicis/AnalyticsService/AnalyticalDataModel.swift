
struct AnalyticalDataModel {
    let event: TypesEventAnalyticalData
    let screen: ScreensAnalytical
    let item: TypesItemsAnalyticalData?
}

enum TypesEventAnalyticalData: String {
    case open
    case close
    case click
}

enum ScreensAnalytical: String {
    case main
}

enum TypesItemsAnalyticalData: String {
    case addTrack
    case track
    case filter
    case edit
    case delete
}
