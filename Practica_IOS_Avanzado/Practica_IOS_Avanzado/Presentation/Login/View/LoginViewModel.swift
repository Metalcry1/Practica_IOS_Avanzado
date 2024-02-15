//
//  LoginViewModel.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 15/11/23.
//

import UIKit

final class LoginViewModel: LoginViewControllerDelegate{
    
    var loginViewState: ((LoginViewState) -> Void)?
    
    
    // MARK: - DEPENDENCIES -
    private let apiProvider: ApiProviderProtocol
    private let keyChain: KeyChainProtocol
    
    
    var heroesViewModel: HeroesViewControllerDelegate {
        HeroesViewModel(
            apiProvider: apiProvider,
            keyChain: keyChain
            
        )
    }
    
    var loginViewModel: LoginViewControllerDelegate{
        LoginViewModel(
            apiProvider: apiProvider,
            keyChain: keyChain)
    }
    
    // MARK: - INICIALIZERS -
    init(
        apiProvider: ApiProviderProtocol,
        keyChain: KeyChainProtocol
        
    ) {
        self.apiProvider = apiProvider
        self.keyChain = keyChain
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onLoginResponse),
            name: NotificationCenter.apiLoginNotification,
            object: nil
        )
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - FUNTIONS -
    
    func botomLoginPress(email: String?, password: String?){
        
        self.loginViewState?(.loading(true))
        self.loginViewState?(.ErrorEmail(false))
        self.loginViewState?(.ErrorPassword(false))
        
        DispatchQueue.main.async {
            guard self.isValidEmail(email: email) else {
                self.loginViewState?(.ErrorEmail(true))
                NotificationCenter.default.post(name: .showAlertEmailorPassword , object: nil)
                
                return
            }
            guard self.isValidPassword(password: password) else {
                self.loginViewState?(.ErrorPassword(true))
                NotificationCenter.default.post(name: .showAlertEmailorPassword , object: nil)
                self.loginViewState?(.loading(false))
                
                return
            }
            
            self.loginConnectToApi(
                email: email ?? "",
                password: password ?? ""
            )
            self.loginViewState?(.ErrorEmail(false))
            self.loginViewState?(.ErrorPassword(false))
            
            var token = self.keyChain.getToken()
            var timesLoop = 0
            
            while(token == nil && timesLoop <= 5){
                token = self.keyChain.getToken()
                sleep(1)
                timesLoop += 1
            }
            
            if token != nil{
                DispatchQueue.main.async {
                    self.loginViewState?(.ErrorNetwork(false))
                    self.loginViewState?(.loading(true))
                    self.loginViewState?(.navigateToNext(true))
                }
            }else{
                print("Vuelve a intentar conectar")
                self.loginViewState?(.ErrorNetwork(true))
                NotificationCenter.default.post(name: .showAlertErrorNetwork , object: nil)

            }
        }
    }
    
    @objc func onLoginResponse(_ notificacion: Notification ){
        print("Respuesta: \(notificacion)")
        
    }
    
    
    func loginConnectToApi(email: String, password: String){
        apiProvider.login(
            for: email,
            with: password)
    }
    
    func isValidEmail(email: String?) -> Bool {
        guard let email = email, !email.isEmpty else {
            return false
        }
        
        let containsSpecialChars = Constants.specialChars.contains { specialChar in
            email.contains(specialChar)
        }
        
        let isValidFormat = email.contains("@") && email.contains(".")
        
        return !containsSpecialChars && isValidFormat
    }
    
    func isValidPassword(password: String?) -> Bool {
        password?.isEmpty == false && (password?.count ?? 0) >= 4
    }
    
}
    



