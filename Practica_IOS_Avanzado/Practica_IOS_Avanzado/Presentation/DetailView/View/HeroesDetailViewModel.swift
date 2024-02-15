//
//  HeroesDetailViewModel.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 22/11/23.
//

import Foundation


final class HeroesDetailViewModel: HeroesDetailViewControllerDelegate {
        
    private let apiProvider: ApiProviderProtocol
    private let keyChain: KeyChainProtocol
    private var hero: Hero
    private var locations: [HeroMapPoint] = []
    private var allLocations : [HeroMapPoint] = []
    private let coreDataProvider =  CoreDataProvider()
    
    var heroesDetailViewStateVar: ((HeroesDetailViewState) -> Void)?
    
    var heroesViewModel: HeroesViewControllerDelegate {
        HeroesViewModel(
            apiProvider: apiProvider,
            keyChain: keyChain
        )
    }
    
    var loginViewModel: LoginViewControllerDelegate {
        LoginViewModel(
            apiProvider: apiProvider,
            keyChain: keyChain
        )
    }
    
    init(
        apiProvider: ApiProviderProtocol,
         keyChain: KeyChainProtocol,
        hero: Hero

    ) {
        self.apiProvider = apiProvider
        self.keyChain = keyChain
        self.hero = hero

    }
    
    
    
    //MARK: - FUNTIONS -
    
    func deleteHeros(){
        coreDataProvider.deleteAllHeroes()
        coreDataProvider.deleteLocations()
        keyChain.deleteToken()
    }
    
    func onViewAppear() {
        heroesDetailViewStateVar?(.loading(true))
                
        DispatchQueue.global().async {
            guard let heroId = self.hero.id else { return }
            guard let token = self.keyChain.getToken() else {
                return
            }
            
            self.apiProvider.getLocations(by: heroId, token: token) { locations in
                self.manageLocations(locations)
                self.heroesDetailViewStateVar?(.loading(false))
                self.heroesDetailViewStateVar?(
                    .updateData(hero: self.hero,
                                locations: self.locations)
                )
            }
        }
    }

    private func manageLocations(_ locations: HeroLocations) {
        self.locations = locations.compactMap { heroLocation in
            guard let latitude = Double(heroLocation.latitude ?? ""),
                  let longitude = Double(heroLocation.longitude ?? "") else {
                return nil
            }

            return HeroMapPoint(
                title: hero.name ?? "Location",
                coordinate: .init(latitude: latitude,
                                  longitude: longitude),
                info: heroLocation.date ?? "Top Secret"
            )
        }
        
    }
}
