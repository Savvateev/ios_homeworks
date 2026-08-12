//
//  AppConfiguration.swift
//  Navigation
//
//  Created by Pavel Savvateev on 12.08.2026.
//
import Foundation

enum AppConfiguration {
    case development(URL)
    case staging(URL)
    case production(URL)
}
