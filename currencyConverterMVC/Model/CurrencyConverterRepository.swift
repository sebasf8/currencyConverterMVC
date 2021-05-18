//
//  CurrencyConverterRepository.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 16/05/2021.
//

import Foundation

class CurrencyConverterRepository {
    var session: URLSession!
    
    init() {
        self.session = URLSession.shared
    }
    
    func getCurrencies() -> [String: String]? {
        guard let filepath = Bundle.main.path(forResource: "currencies", ofType: "json") else { return nil }
        
        do {
            let data =  try String(contentsOfFile: filepath).data(using: .utf8)!
            return try JSONDecoder().decode([String: String].self, from: data)
        } catch {
            return nil
        }
    }
        
    func getLatestRate(from base: String, completion: @escaping(RateResponse?, Error?) -> Void) {
        guard var url = URL(string:  Constants.api.latestRate, relativeTo: Constants.api.getBaseURL()) else {

            fatalError("Malformed URL at \(#function)")
        }
        
        url.appendPathComponent(base)

        session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: 10, userInfo: nil))
                return
            }

            do {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                decoder.dateDecodingStrategy = .formatted(formatter)
                
                let rates =  try decoder.decode(RateResponse.self, from: data)
                completion(rates, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
