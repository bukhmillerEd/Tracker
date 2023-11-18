
import Foundation

struct StatisticsModel {
    private var dataProvider = DataProviderForCoreData(delegate: nil)
    
    func getStatisrics() -> UInt {
        return dataProvider.getCompletedTrackers()
    }
}
