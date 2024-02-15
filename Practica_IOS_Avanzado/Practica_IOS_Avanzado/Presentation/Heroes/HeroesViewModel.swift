//
//  HeroesViewModel.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 19/11/23.
//

import UIKit

final class HeroesViewModel : HeroesViewControllerDelegate{
    
    
    
    // MARK: - DEPENDENCIES -
    private let apiProvider: ApiProviderProtocol
    private let keyChain: KeyChainProtocol
    private let coreDataProvider =  CoreDataProvider()
    private var heroes: Heroes = []
    var heroesViewStateVar: ((HeroesViewState) -> Void)?
    var heroesCount: Int {heroes.count}
    
    //MARK: - INJECTS -
    
    var loginViewModel: LoginViewControllerDelegate {
        LoginViewModel(
            apiProvider: apiProvider,
            keyChain: keyChain
        )
    }
    
    func heroesDetailViewModel(index: Int) -> HeroesDetailViewControllerDelegate?{
        guard let selectedHero = heroInd(index: index) else {return nil}
        return HeroesDetailViewModel(
            apiProvider: apiProvider,
            keyChain: keyChain,
            hero: selectedHero
        )
    }
    
    var heroesAllMapViewModel: HeroesAllMapViewControllerDelegate {
        HeroesAllMapViewModel(
            keyChain: keyChain
        )
    }
    
    
    //MARK: - INICIALIZERS -
    init(
        apiProvider: ApiProviderProtocol,
        keyChain: KeyChainProtocol
    ) {
        self.apiProvider = apiProvider
        self.keyChain = keyChain
    }
    
    //MARK: - FUNTIONS -
    
    func deleteHeros(){
        coreDataProvider.deleteAllHeroes()
        coreDataProvider.deleteLocations()
        keyChain.deleteToken()
    }

    func heroInd(index: Int) -> Hero? {
        if index >= 0 && index < heroesCount {
            heroes[index]
        } else {
            nil
        }
    }
    
    func onViewAppear(){
        heroesViewStateVar?(.loading(true))
        
        defer { heroesViewStateVar?(.loading(false)) }
        guard let token = self.keyChain.getToken() else { return }
        
        if heroes.isEmpty {
        heroes = coreDataProvider.getHeroes()
            
        }
        if self.heroes.count < 1 {
            print("Si no hay heroes guardados en el core llamo a la api")
            DispatchQueue.global().async { [weak self] in
                
                defer { self?.heroesViewStateVar?(.loading(true)) }
//                self?.heroesViewStateVar?(.loading(true))
                self?.apiProvider.getHeroes(by: nil,token: token) { heroes in
                    
                    self?.heroes = heroes
                    self?.heroesViewStateVar?(.loading(false))
                    self?.heroesViewStateVar?(.updateData)
                    print("Guardo en el CoreData")
                    DispatchQueue.main.async {
                        self?.coreDataProvider.saveHeroes(of: heroes)
                    }
                }
            }
        }else{
            self.heroesViewStateVar?(.updateData)
            self.heroesViewStateVar?(.loading(false))
        }
        
    }
}
