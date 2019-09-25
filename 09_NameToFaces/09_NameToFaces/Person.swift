//
//  Person.swift
//  09_NameToFaces
//
//  Created by Jonas Kübler on 07.09.19.
//  Copyright © 2019 Jonas.K. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(image, forKey: "image")
    }
    
    required init?(coder: NSCoder) {
        name = coder.decodeObject(forKey: "name") as? String ?? ""
        image = coder.decodeObject(forKey: "image") as? String ?? ""
    }
    
    
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

}
