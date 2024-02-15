//
//  SplashViewModel.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 15/11/23.
//

import Foundation


final class SplashViewModel: SplashViewControllerDelegate{
    
    // MARK: - Dependencies -
    private let apiProvider: ApiProviderProtocol
    private let keyChain: KeyChainProtocol
    
    var loginViewModel: LoginViewControllerDelegate {
        LoginViewModel(
            apiProvider: apiProvider,
            keyChain: keyChain
        )
    }
    
    var heroesViewModel: HeroesViewControllerDelegate {
        HeroesViewModel(
            apiProvider: apiProvider,
            keyChain: keyChain
        )
    }
    // MARK: - Initializers -
    init(
        apiProvider: ApiProviderProtocol,
        keyChain: KeyChainProtocol
    ) {
        self.apiProvider = apiProvider
        self.keyChain = keyChain
    }
}
