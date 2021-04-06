//
//  ChartViewModel.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 3/28/21.
//

import SwiftUI

class ChartViewModel: ObservableObject {
    
    @Published var dataSet = [CovidData.Records.Fields]()
    @Published var latestDataSet = CovidData.Records.Fields()
    @Published var inProgress = false
    
    init() {
        getData()
    }
    
    func getLatestDataSet() {
        guard let lastResult = dataSet.first else { return }
        DispatchQueue.main.async {
            self.latestDataSet = lastResult
        }
        
    }
    
    func getData() {
        self.inProgress = true
        let urlString = "https://www.data.gov.qa/api/records/1.0/search/?dataset=covid-19-cases-in-qatar&q=&lang=en&rows=90&sort=date&facet=date"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            //Check for errors
            if let error = err {
                self.inProgress = false
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let covidData = try JSONDecoder().decode(CovidData.self, from: data)
                
                covidData.records.forEach { (dayData) in
                    DispatchQueue.main.async {
                        self.dataSet.append(dayData.fields)
                    }
                }
                self.getLatestDataSet()
                DispatchQueue.main.async {
                    self.inProgress = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.inProgress = false
                }
                print("JSON decode error", error)
            }
        }.resume()
    }
    
    func getPositiveCases() -> [CGFloat] {
        var positiveCases: [CGFloat] = []
        dataSet.forEach { (record) in
            positiveCases.append(CGFloat(record.numberOfNewPositiveCasesInLast24Hrs ?? 0))
        }
        return positiveCases
    }
    
    func getDeathCases() -> [Double] {
        var deathCases: [Double] = []
        dataSet.forEach { (record) in
            deathCases.append(Double(record.numberOfNewDeathsInLast24Hrs ?? 0))
        }
        return deathCases
    }
    
    func getPercentPositive() -> [Double] {
        var percentPositive: [Double] = []
        dataSet.forEach { (record) in
            percentPositive.append(Double(record.numberOfNewPositiveCasesInLast24Hrs ?? 0) / Double(record.numberOfNewPositiveCasesInLast24Hrs ?? 0) * 100)
        }
        return percentPositive
    }
    
    func isPositiveCasesIncreasing() -> Bool {
        if !dataSet.isEmpty {
            let lastTwoDaysDataSet = dataSet[0..<2]
            guard let yesterday = lastTwoDaysDataSet.first?.numberOfNewPositiveCasesInLast24Hrs, let theDayBeforeYesterday = lastTwoDaysDataSet.last?.numberOfNewPositiveCasesInLast24Hrs else { return false }
            return yesterday > theDayBeforeYesterday
        } else {
            return false
        }  
    }
    
    func isDeathCasesIncreasing() -> Bool {
        if !dataSet.isEmpty {
            let lastTwoDaysDataSet = dataSet[0..<2]
            guard let yesterday = lastTwoDaysDataSet.first?.numberOfNewDeathsInLast24Hrs, let theDayBeforeYesterday = lastTwoDaysDataSet.last?.numberOfNewDeathsInLast24Hrs else { return  false }
            return yesterday > theDayBeforeYesterday
        } else {
            return false
        }
    }
}
