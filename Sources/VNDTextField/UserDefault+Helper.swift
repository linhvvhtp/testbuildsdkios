//
//  File.swift
//  
//
//  Created by Vu Viet Linh on 05/10/2023.
//

import Foundation

enum Defaults: String {
    case suggestions
}

final class UserDefaultHelper {
    // Access shared defaults object
    static let userDefaults = UserDefaults.standard
    
    static var suggestions: [String]? {
        set {
            saveSuggest(value: newValue, key: .suggestions)
        } get {
            return readSuggest(valueForKey: .suggestions) ?? []
        }
    }
    
    static func saveSuggest(value: [String]?, key: Defaults) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    static func readSuggest(valueForKey key: Defaults)-> [String]? {
        return userDefaults.value(forKey: key.rawValue) as? [String]
    }
}
