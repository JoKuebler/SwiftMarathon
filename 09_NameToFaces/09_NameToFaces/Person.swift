//
//  Person.swift
//  09_NameToFaces
//
//  Created by Jonas Kübler on 07.09.19.
//  Copyright © 2019 Jonas.K. All rights reserved.
//

import UIKit

class Person: NSObject {
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}
