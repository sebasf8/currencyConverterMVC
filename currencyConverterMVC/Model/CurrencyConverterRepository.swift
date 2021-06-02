//
//  CurrencyConverterRepository.swift
//  currencyConverterMVC
//
//  Created by Sebastian Fernandez on 16/05/2021.
//

import Foundation

class CurrencyConverterRepository {
    var session: URLSession
    
    init() {
        self.session = URLSession.shared
    }
    
    func getCurrencies() -> [Currency] {
        guard let filepath = Bundle.main.path(forResource: "currencies", ofType: "json") else {
            fatalError("No currencies file found")
        }
        
            let file =  try! String(contentsOfFile: filepath)
            let data = file.data(using: .utf8)!
        
            let currencies = try! JSONDecoder().decode([String: String].self, from: data)
            
            return currencies.compactMap { (key, value) in
                Currency(shortName: key, name: value)
            }
    }
        
    func getLatestRate(from base: String, completion: @escaping(Result<RateGroup, Error>) -> Void) {
        guard var url = URL(string:  Constants.API.latestRate, relativeTo: Constants.API.getBaseURL()) else {

            fatalError("Malformed URL at \(#function)")
        }
        
        url.appendPathComponent(base)

        session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(error!))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.noResponse))
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                decoder.dateDecodingStrategy = .formatted(formatter)
                
                let rates =  try decoder.decode(RateResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(rates))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(NetworkingError.parsingError))
                }
            }
        }.resume()
    }
}
