//
//  UIApplication+AppDependency.swift
//  Countries
//
//  Created by Gabriele Nardi on 27/12/23.
//

import UIKit
import Core
import Mock

public extension UIApplication {
    
    static let dependencies: AppDependenciesRepresentable = {
        #if MOCK
        MockAppDependencies()
        #else
        AppDependencies()
        #endif
    }()
}


