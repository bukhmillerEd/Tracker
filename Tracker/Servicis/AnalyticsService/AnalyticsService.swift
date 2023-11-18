import Foundation
import YandexMobileMetrica

struct AnalyticsService: AnalyticsServiceProtocol {
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "5d75ec4d-afca-4382-a7af-e89f865da4ba") else { return }
        
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(analyticalDataModel model: AnalyticalDataModel) {
        var params: [AnyHashable : Any] = ["screen": model.screen.rawValue]
        if let item = model.item?.rawValue {
            params["item"] = item
        }
        YMMYandexMetrica.reportEvent(model.event.rawValue, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}

