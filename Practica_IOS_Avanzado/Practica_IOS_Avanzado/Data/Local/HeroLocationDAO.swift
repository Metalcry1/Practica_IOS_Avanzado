//
//  HeroeLocationDAO.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 29/11/23.
//

import UIKit
import CoreData

@objc(HeroLocationDAO)
class HeroLocationDAO: NSManagedObject {
    static let entityName = "HeroLocationDAO"
    
    @NSManaged var id: String?
    @NSManaged var date: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var hero: String?
    
}

extension HeroLocationDAO {
    
    static func mapHeroLocationDao(of heroLocationDAO: [HeroLocationDAO]) -> HeroLocations {
        heroLocationDAO.map { heroLocationDAO in
            HeroLocation(
                id: heroLocationDAO.id,
                latitude: heroLocationDAO.latitude,
                longitude: heroLocationDAO.longitude,
                date: heroLocationDAO.date,
                hero: Hero(
                    id: heroLocationDAO.hero,
                    name: nil,
                    description: nil,
                    photo: nil,
                    isFavorite: nil)
            )
        }
    }
}
