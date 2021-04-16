//
//  ListViewModel.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 4/5/21.
//

import SwiftUI

class ListViewModel: ObservableObject {
    
    private let servicesAPI = ServicesAPI()
    @Published var data = [CovidData.Records.Fields]()
    @Published var inProgress = false
    @Published var numberOfDays = 30
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        self.inProgress = true
        self.data.removeAll()
        
        servicesAPI.fetchData(numberOfDays: numberOfDays) { results in
            switch results {
            case .success(let data):
                data.records.forEach { record in
                    self.data.append(record.fields)
                }
                self.inProgress = false
            case .failure(_):
                self.inProgress = false
                return
            }
        }
    }
    
    func getMaxTests() -> CGFloat {
        var allTests: [Int] = []
        if !data.isEmpty {
            allTests = data.map { ($0.numberOfNewTestsInLast24Hrs ?? 0) }
        }
        return CGFloat(allTests.max() ?? 0)
    }
    func getMaxPositive() -> CGFloat {
        var allTests: [Int] = []
        if !data.isEmpty {
            allTests = data.map { ($0.numberOfNewPositiveCasesInLast24Hrs ?? 0) }
        }
        return CGFloat(allTests.max() ?? 0)
    }
    func getMaxDeaths() -> CGFloat {
        var allTests: [Int] = []
        if !data.isEmpty {
            allTests = data.map { ($0.numberOfNewDeathsInLast24Hrs ?? 0) }
        }
        return CGFloat(allTests.max() ?? 0)
    }
}
