//
//  MultipleHeroAnnotation.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 29/11/23.
//

import Foundation
import MapKit
class MultipleHeroMapPoint: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var info: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String? = nil, info: String? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.info = info
    }
}
