//
//  Petition.swift
//  07_CodableDemo
//
//  Created by Jonas Kübler on 11.08.19.
//  Copyright © 2019 Jonas.K. All rights reserved.
//

import Foundation

struct Petition: Codable {
    
    var title: String
    var body: String
    var signatureCount: Int
}
