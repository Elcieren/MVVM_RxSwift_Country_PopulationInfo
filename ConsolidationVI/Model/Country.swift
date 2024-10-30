//
//  Country.swift
//  ConsolidationVI
//
//  Created by Eren Elçi on 30.10.2024.
//

import Foundation

import Foundation


struct Country: Codable {
    let error: Bool
    let msg: String
    let data: [Datum]
}


struct Datum: Codable {
    let city: String
    let country: String
    let populationCounts: [PopulationCount]
}


struct PopulationCount: Codable {
    let year: String
    let value: String?
    let sex: Sex?
    let reliabilty: Reliabilty?
}

enum Reliabilty: String, Codable {
    case cityInner = "city inner"
    case finalFigureComplete = "Final figure, complete"
    case otherEstimate = "Other estimate"
    case provisionalFigure = "Provisional figure"
}

enum Sex: String, Codable {
    case bothSexes = "Both Sexes"
    case usually = "usually"
}

