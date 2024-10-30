//
//  CountryTableViewCell.swift
//  ConsolidationVI
//
//  Created by Eren Elçi on 30.10.2024.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet var populationLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var countryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
    public var item : Datum! {
        didSet {
            self.countryLabel.text = "Country: \(item.country)"
            self.cityLabel.text = "City: \(item.city)"
            if let latestPopulation = item.populationCounts.last?.value {
                        self.populationLabel.text = "Population: \(latestPopulation)"
                    } else {
                        self.populationLabel.text = "No data"
                    }
        }
    }

}
