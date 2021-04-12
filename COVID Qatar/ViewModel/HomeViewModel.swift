//
//  HomeViewModel.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 3/29/21.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    
    private var servicesAPI = ServicesAPI()
    private var dataSet = [CovidData.Records.Fields]()
    @Published var latestDaySnapshot = CovidData.Records.Fields()
    @Published var inProgress = false
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        inProgress = true
        servicesAPI.fetchData(numberOfDays: 2) { results in
            switch results {
            
            case .success(let data):
                data.records.forEach { (record) in
                    self.dataSet.append(record.fields)
                }
                guard let lastDay = data.records.first?.fields else { return }
                self.latestDaySnapshot = lastDay
                self.inProgress = false
            case .failure(_):
                self.inProgress = false
                return
            }
        }
    }
    
    func isPositiveCasesIncreasing() -> CasesIncrease {
        var whatIsHappening: CasesIncrease = .equal
        
        if !dataSet.isEmpty {
            let lastTwoDaysDataSet = dataSet[0..<2]
            if let yesterday = lastTwoDaysDataSet.first?.numberOfNewPositiveCasesInLast24Hrs, let theDayBeforeYesterday = lastTwoDaysDataSet.last?.numberOfNewPositiveCasesInLast24Hrs {
                if yesterday < theDayBeforeYesterday {
                    whatIsHappening = .decreasing
                } else if yesterday > theDayBeforeYesterday {
                    whatIsHappening = .increasing
                } else {
                    whatIsHappening = .equal
                }
            }
        }
        
        return whatIsHappening
    }
    
    func isNumberOfTestsIncreasing() -> CasesIncrease {
        var whatIsHappening: CasesIncrease = .equal
        if !dataSet.isEmpty {
            let lastTwoDaysDataSet = dataSet[0..<2]
            if let yesterday = lastTwoDaysDataSet.first?.numberOfNewTestsInLast24Hrs, let theDayBeforeYesterday = lastTwoDaysDataSet.last?.numberOfNewTestsInLast24Hrs {
                if yesterday < theDayBeforeYesterday {
                    whatIsHappening = .decreasing
                } else if yesterday > theDayBeforeYesterday {
                    whatIsHappening = .increasing
                } else {
                    whatIsHappening = .equal
                }
            }
        }
        
        return whatIsHappening
    }
    
    func isDeathCasesIncreasing() -> CasesIncrease {
        var whatIsHappening: CasesIncrease = .equal
        
        if !dataSet.isEmpty {
            let lastTwoDaysDataSet = dataSet[0..<2]
            if let yesterday = lastTwoDaysDataSet.first?.numberOfNewDeathsInLast24Hrs, let theDayBeforeYesterday = lastTwoDaysDataSet.last?.numberOfNewDeathsInLast24Hrs {
                if yesterday < theDayBeforeYesterday {
                    whatIsHappening = .decreasing
                } else if yesterday > theDayBeforeYesterday {
                    whatIsHappening = .increasing
                } else {
                    whatIsHappening = .equal
                }
            }
        }
        
        return whatIsHappening
    }
    
    func isCurrentICUCasesIncreasing() -> CasesIncrease {
        var whatIsHappening: CasesIncrease = .equal
        
        if !dataSet.isEmpty {
            let lastTwoDaysDataSet = dataSet[0..<2]
            if let yesterday = lastTwoDaysDataSet.first?.totalNumberOfCasesUnderIcuTreatment, let theDayBeforeYesterday = lastTwoDaysDataSet.last?.totalNumberOfCasesUnderIcuTreatment {
                if yesterday < theDayBeforeYesterday {
                    whatIsHappening = .decreasing
                } else if yesterday > theDayBeforeYesterday {
                    whatIsHappening = .increasing
                } else {
                    whatIsHappening = .equal
                }
            }
        }
        
        return whatIsHappening
    }
    
    func isCurrentHospitalizedCasesIncreasing() -> CasesIncrease {
        var whatIsHappening: CasesIncrease = .equal
        
        if !dataSet.isEmpty {
            let lastTwoDaysDataSet = dataSet[0..<2]
            if let yesterday = lastTwoDaysDataSet.first?.totalNumberOfAcuteCasesUnderHospitalTreatment, let theDayBeforeYesterday = lastTwoDaysDataSet.last?.totalNumberOfAcuteCasesUnderHospitalTreatment {
                if yesterday < theDayBeforeYesterday {
                    whatIsHappening = .decreasing
                } else if yesterday > theDayBeforeYesterday {
                    whatIsHappening = .increasing
                } else {
                    whatIsHappening = .equal
                }
            }
        }
        
        return whatIsHappening
    }
    
    func isCurrentActiveCasesIncreasing() -> CasesIncrease {
        var whatIsHappening: CasesIncrease = .equal
        
        if !dataSet.isEmpty {
            let lastTwoDaysDataSet = dataSet[0..<2]
            if let yesterday = lastTwoDaysDataSet.first?.totalNumberOfActiveCasesUndergoingTreatmentToDate, let theDayBeforeYesterday = lastTwoDaysDataSet.last?.totalNumberOfActiveCasesUndergoingTreatmentToDate {
                if yesterday < theDayBeforeYesterday {
                    whatIsHappening = .decreasing
                } else if yesterday > theDayBeforeYesterday {
                    whatIsHappening = .increasing
                } else {
                    whatIsHappening = .equal
                }
            }
        }
        
        return whatIsHappening
    }
    
}


enum CasesIncrease {
    case increasing
    case decreasing
    case equal
}
