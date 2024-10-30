//
//  Webservice.swift
//  ConsolidationVI
//
//  Created by Eren Elçi on 30.10.2024.
//

import Foundation

enum CountryError : Error {
    case serverError
    case parsingError
}


class Webservice {
    
    func dowloadCountry(url: URL , completion: @escaping (Result<[Datum] , CountryError>) -> ()) {
        URLSession.shared.dataTask(with: url) { (data , response , error) in
            if let _ = error {
                completion(.failure(CountryError.serverError))
            } else if let data = data {
                let country = try? JSONDecoder().decode(Country.self, from: data)
                if let country = country {
                    completion(.success(country.data))
                }
                 else {
                    completion(.failure(CountryError.parsingError))
                }
            }
        }.resume()
    }
}
