import Foundation

struct StatisticsViewModel {
    
    @Observable
    private(set) var statistics: [StatisticsCellModel] = []
    
    private let statisticsModel = StatisticsModel()
    
    func getStatisrics() {
        let completedTrackers = statisticsModel.getStatisrics()
        statistics  = completedTrackers == 0 ? [] : [StatisticsCellModel(coutn: completedTrackers, name: "Трекеров завершено")]
    }
    
}
