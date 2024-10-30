//
//  DetailCountryViewController.swift
//  ConsolidationVI
//
//  Created by Eren Elçi on 30.10.2024.
//

import UIKit

class DetailCountryViewController: UIViewController {

    @IBOutlet var detailYearLabel: UILabel!
    @IBOutlet var detailcountryLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
    var selectedCountry: Datum?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .black
        
        if let country = selectedCountry {
            cityLabel.text = "City: \(country.city)"
            detailcountryLabel.text = "Country: \(country.country)"
            
            var populationInfo = ""
            for population in country.populationCounts {
                if let value = population.value {
                    populationInfo += "Year: \(population.year), Population: \(value)\n"
                }
            }
            detailYearLabel.text = populationInfo
        }

        
    }
    

    

}
