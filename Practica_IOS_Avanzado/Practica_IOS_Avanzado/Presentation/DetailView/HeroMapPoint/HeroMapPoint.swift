//
//  HeroMapPoint.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 22/11/23.
//

import MapKit
import UIKit

class HeroMapPoint: NSObject, MKAnnotation{
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String?
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D, info: String? = nil) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        
    }
}
