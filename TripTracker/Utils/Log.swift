//
//  Log.swift
//  TripTracker
//
//  Created by S. M. Hasibur Rahman on 8/23/21.
//  Copyright © 2021 S. M. Hasibur Rahman. All rights reserved.
//

struct Log {
    static func debug(tag: String, function: String, msg: String = "") {
        print("\(tag) \(function): \(msg)")
    }
}
