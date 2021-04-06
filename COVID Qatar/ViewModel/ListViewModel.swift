//
//  ListViewModel.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 4/5/21.
//

import Foundation

class ListViewModel: ObservableObject {
    
    private let servicesAPI = ServicesAPI()
    @Published var data = [CovidData.Records.Fields]()
    @Published var inProgress = false
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        self.inProgress = true
        self.data.removeAll()
        
        servicesAPI.fetchData(numberOfDays: -1) { results in
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
}
