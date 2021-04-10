//
//  ChartViewModel.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 3/28/21.
//

import SwiftUI

class ChartViewViewModel: ObservableObject {
    
    private var serviceAPI = ServicesAPI()
    @Published var inProgress = false
    @Published var numberOfCases = [CGFloat]()
    @Published var chartNumberOfDaysTab = 1
    @Published var chartPositiveOrDeathTab = 0
    @Published var chartType = 0
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        inProgress = true
        numberOfCases.removeAll()
        serviceAPI.fetchData(numberOfDays: chartNumberOfDaysTab == 0 ? 30 : chartNumberOfDaysTab == 1 ? 90 : -1) { results in
            switch results {
            case .success(let data):
                data.records.forEach { record in
                    self.numberOfCases.append(self.chartPositiveOrDeathTab == 0 ? CGFloat(record.fields.numberOfNewPositiveCasesInLast24Hrs ?? 0) : self.chartPositiveOrDeathTab == 1 ? CGFloat(record.fields.numberOfNewDeathsInLast24Hrs ?? 0) : (CGFloat(record.fields.numberOfNewPositiveCasesInLast24Hrs ?? 0) / CGFloat(record.fields.numberOfNewTestsInLast24Hrs ?? 0)) * 100)
                }
                self.inProgress = false
            case .failure(let err):
                self.inProgress = false
                print(err.localizedDescription)
            }
        }
    }
}
