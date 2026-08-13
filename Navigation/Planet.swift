//
//  Planet.swift
//  Navigation
//
//  Created by Pavel Savvateev on 13.08.2026.
//
import Foundation

struct Planet: Decodable {
    let name: String
    let rotationPeriod: String
    let orbitalPeriod: String
    let diameter: String
    let climate: String
    let population: String

    enum CodingKeys: String, CodingKey {
        case name
        case rotationPeriod = "rotation_period"
        case orbitalPeriod = "orbital_period"
        case diameter
        case climate
        case population
    }
}
