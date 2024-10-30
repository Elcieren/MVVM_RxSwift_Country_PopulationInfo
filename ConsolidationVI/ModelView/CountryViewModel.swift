//
//  CountryViewModel.swift
//  ConsolidationVI
//
//  Created by Eren Elçi on 30.10.2024.
//

import Foundation
import RxSwift
import RxCocoa


class CountryViewModel {
    
    let country : PublishSubject<[Datum]> = PublishSubject()
    let error : PublishSubject<String> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject()
    
    
    func requestData() {
        self.loading.onNext(true)
        let url = URL(string: "https://countriesnow.space/api/v0.1/countries/population/cities")!
        Webservice().dowloadCountry(url: url) { result in
            self.loading.onNext(false)
            switch result {
            case .success(let country):
                self.country.onNext(country)
            case .failure(let error):
                switch error {
                case .parsingError:
                    self.error.onNext("Parsin Error")
                case .serverError:
                    self.error.onNext("Server Error")
                }
            }
        }
    }
    
    
    
}
