//
//  HeroesAllMapViewModel.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 23/11/23.
//

import Foundation


final class HeroesAllMapViewModel: HeroesAllMapViewControllerDelegate {
    
    private let apiProvider = ApiProvider()
    private let keyChain: KeyChainProtocol
    private var heroesLocations: HeroLocations = []
    private let coreDataProvider :  CoreDataProvider = .init()
    private var heroes: Heroes = []

    var heroesAllMapviewState: ((HeroesAllMapViewState) -> Void)?
    
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
    
    // MARK: - INICIALIZERS -
    init(
        keyChain: KeyChainProtocol
    ){
        self.keyChain = keyChain
    }
    
    
    //MARK: - FUNTIONS -
    
    func deleteHeros(){
        coreDataProvider.deleteAllHeroes()
        coreDataProvider.deleteLocations()
        keyChain.deleteToken()
    }
    
    func onViewAppear() {
        defer { heroesAllMapviewState?(.loading(false)) }
        
        heroesAllMapviewState?(.loading(true))
        
        DispatchQueue.global().async {
            guard let token = self.keyChain.getToken() else {
                return
            }
            
            self.heroes = self.coreDataProvider.getHeroes()
            print(self.heroes.count)
            
            self.heroes.forEach { hero in
                self.heroesLocations = self.coreDataProvider.getLocations(by: hero.id ?? "")
                if  !self.heroesLocations.isEmpty {
                    self.heroesAllMapviewState?(.update(hero: hero, locations: self.heroesLocations ))
                } else {
                    self.apiProvider.getLocations(
                        by: hero.id,
                        token: token
                    ) { [weak self] heroLocation in
                        
                        self?.heroesAllMapviewState?(.update(hero: hero, locations: heroLocation))
                        DispatchQueue.main.async {
                            self?.coreDataProvider.saveLocations(of: heroLocation)
                        }
                        

                    }
                }
            }
            
        }
    }
}
