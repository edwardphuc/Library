//
//  API.swift
//  Library
//
//  Created by Edward Lauv on 8/26/20.
//  Copyright © 2020 Edward Lauv. All rights reserved.
//

import Foundation
class API {
    static let instance = API()
    var baseURL: String {
        "https://coronavirus-19-api.herokuapp.com/countries/"
    }
    func URL(path: String) -> String {
        return baseURL + path
    }
}
