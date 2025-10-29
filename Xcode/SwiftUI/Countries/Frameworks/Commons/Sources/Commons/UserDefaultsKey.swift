//
//  UserDefaultsKey.swift
//  Commons
//
//  Created by Gabriele Nardi   on 28/10/25.
//

import Foundation

extension UserDefaults {
    
    public static func saveFirstApplicationLaunch() {
        UserDefaults.standard.setValue(true, forKey: UserDefaultsKey.firstLaunch.rawValue)
    }
    
    public static func checkFirstApplicationLaunch() -> Bool {
        UserDefaults.standard.bool(forKey: UserDefaultsKey.firstLaunch.rawValue)
    }
}

// MARK: - UserDefaultsKey

enum UserDefaultsKey: String {
    case firstLaunch
}
