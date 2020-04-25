//
//  File.swift
//  90's
//
//  Created by 홍정민 on 2020/04/25.
//  Copyright © 2020 홍정민. All rights reserved.
//

import Foundation

protocol APIManager {}

extension APIManager {
    static func url(_ path: String) -> String {
        return "http://49.50.162.246:443" + path
    }
}
