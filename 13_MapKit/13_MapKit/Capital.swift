//
//  Capital.swift
//  13_MapKit
//
//  Created by Jonas Kübler on 04.11.19.
//  Copyright © 2019 Jonas Kübler. All rights reserved.
//

import UIKit
import MapKit

class Capital: NSObject, MKAnnotation {

    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
