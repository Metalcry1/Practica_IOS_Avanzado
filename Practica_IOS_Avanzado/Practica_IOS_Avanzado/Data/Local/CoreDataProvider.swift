//
//  CoreDataStack.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 29/11/23.
//

import Foundation
import CoreData

public class CoreDataProvider {
    
    
    func saveHeroes(of heroes: Heroes) {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        guard let heroEntity = NSEntityDescription.entity(forEntityName: HeroDAO.entityName, in: moc)
        else {
            return
        }
        
        heroes.forEach { hero in
            let heroDAO = HeroDAO(entity: heroEntity, insertInto: moc)
            heroDAO.favorite = hero.isFavorite ?? false
            heroDAO.heroDescription = hero.description
            heroDAO.id = hero.id
            heroDAO.name = hero.name
            heroDAO.photo = hero.photo
        }
        try? moc.save()
    }
    
    func getHeroes() -> Heroes {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        
        guard let heroes = try? moc.fetch(fetch)
        else {
            return []
        }
        return HeroDAO.mapHeroDAO(of: heroes)
    }
    
    func saveLocations(of locations: HeroLocations) {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        guard let heroEntity = NSEntityDescription.entity(
            forEntityName: HeroLocationDAO.entityName,
            in: moc
        ) else {
            return
        }
        
        locations.forEach { location in
            let herolocationDAO = HeroLocationDAO(entity: heroEntity, insertInto: moc)
            herolocationDAO.date = location.date
            herolocationDAO.id = location.id
            herolocationDAO.latitude = location.latitude
            herolocationDAO.longitude = location.longitude
            herolocationDAO.hero = location.hero?.id
        }
        try? moc.save()
    }
    
    func getLocations(by hero: String) -> HeroLocations {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let fetch = NSFetchRequest<HeroLocationDAO>(entityName: HeroLocationDAO.entityName)
        
        guard let locations = try? moc.fetch(fetch)
        else {
            return []
        }
        return HeroLocationDAO.mapHeroLocationDao(of: locations)
    }
    
    public func deleteAllHeroes() {
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let requestAllHeroes = NSFetchRequest<HeroDAO>(entityName: HeroDAO.entityName)
        
        guard let heroes = try? moc.fetch(requestAllHeroes)
        else {
            return
        }
        heroes.forEach { heroe in
            moc.delete(heroe)
        }
        try? moc.save()
    }
    
    public func deleteLocations(){
        let moc = CoreDataStack.shared.persistentContainer.viewContext
        let requestAllLocations = NSFetchRequest<HeroLocationDAO>(entityName: HeroLocationDAO.entityName)
        
        guard let locations = try? moc.fetch(requestAllLocations)
        else {
            return
        }
        locations.forEach{ loca in
            moc.delete(loca)
        }
        try? moc.save()
    }
}
