//
//  SplashViewController.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 15/11/23.
//


import UIKit

protocol SplashViewControllerDelegate{
    var loginViewModel: LoginViewControllerDelegate { get }
    var heroesViewModel: HeroesViewControllerDelegate { get }
    
}

final class SplashViewController: UIViewController{
    
    let keyChain = KeyChain()
    var viewModel: SplashViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkTokenSplash()
    }
    
    
    //MARK: - FUNTIONS -
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case Constants.LoginSegue:
            let loginViewController = segue.destination as? LoginViewController
            loginViewController?.viewModel = viewModel?.loginViewModel
            
        case Constants.HeroesSegue:
            let heroesViewController = segue.destination as? HeroesViewController
            heroesViewController?.viewModel = viewModel?.heroesViewModel
            
        default:
            break
        }
    }
    
    func checkTokenSplash (){
        
        if let token = keyChain.getToken(), !token.isEmpty {
            navigateToHeroes()
        } else {
            navigateToLogin()
        }
    }
    
    func navigateToLogin(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ [weak self] in
            self?.performSegue(withIdentifier: Constants.LoginSegue,
                               sender: nil)
        }
    }
    func navigateToHeroes(){
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ [weak self] in
                self?.performSegue(withIdentifier: Constants.HeroesSegue,
                                   sender: nil)
            }
    }
}
