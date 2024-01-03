//
//  Logger.swift
//
//
//  Created by Gabriele Nardi on 27/12/23.
//

import Foundation
import Commons

let logger = Logger(options: .verbose, icon: "💾", subsystem: Bundle.main.bundleIdentifier ?? "-", category: "/DataModel")
