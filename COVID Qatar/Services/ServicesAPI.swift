//
//  ServicesAPI.swift
//  COVID Qatar
//
//  Created by Omar Al-Ansari on 4/3/21.
//

import Foundation

class ServicesAPI: ObservableObject {
 
    func fetchData(numberOfDays: Int, completion: @escaping (Result<CovidData, Error>) -> Void) {
        
        let urlString = "https://www.data.gov.qa/api/records/1.0/search/?dataset=covid-19-cases-in-qatar&q=&lang=en&rows=\(numberOfDays)&sort=date&facet=date"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let covidData = try JSONDecoder().decode(CovidData.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(covidData))
                }
                
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum FetchingError: Error {
    case urlError
    case unknown
}
