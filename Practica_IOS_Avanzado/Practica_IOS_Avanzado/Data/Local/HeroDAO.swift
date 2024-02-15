//
//  HeroDAO.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 29/11/23.
//

import Foundation
import CoreData

@objc(HeroDAO)
class HeroDAO: NSManagedObject {
    static let entityName = "HeroDAO"

    @NSManaged var id: String?
    @NSManaged var name: String?
    @NSManaged var heroDescription: String?
    @NSManaged var photo: String?
    @NSManaged var favorite: Bool
}



extension HeroDAO{
    
    static func mapHeroDAO(of heroesDAO: [HeroDAO]) -> Heroes {
        heroesDAO.map { heroDAO in
            Hero(
                id: heroDAO.id,
                name: heroDAO.name,
                description: heroDAO.heroDescription,
                photo: heroDAO.photo,
                isFavorite: heroDAO.favorite
            )
        }
    }
}
