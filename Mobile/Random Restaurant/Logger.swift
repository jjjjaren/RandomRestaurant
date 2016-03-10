//
//  Logger.swift
//  Random Restaurant
//
//  Created by Jaren Hamblin on 2/4/16.
//  Copyright © 2016 JHamblin. All rights reserved.
//

import Foundation

class Logger: Engine {
    func debug(m: AnyObject) {
        print("[Debug] \(m)")
    }
    func debug(m: String) {
        print("[Debug] \(m)")
    }
    func debug(m: String?) {
        print("[Debug] \(m ?? "")")
    }
    func error(m: AnyObject) {
        print("[Debug] \(m)")
    }
    func error(m: String) {
        print("[Error] \(m)")
    }
    func error(m: String?) {
        print("[Error] \(m ?? "")")
    }
}

let log = Logger()