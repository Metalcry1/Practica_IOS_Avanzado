//
//  Constants.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 16/11/23.
//

import Foundation

class Constants{
    //MARK: - SEGUES -
    static let HeroesSegue = "HEROES_SEGUE"
    static let LoginSegue = "LOGIN_SEGUE"
    static let DetailSegue = "DETAIL_SEGUE"
    static let HeroesAllMapSegue = "HEROESALLMAP_SEGUE"
    
    //MARK: - REST -
    static let specialChars = ["#", "$", "%", "&", "!", "*", "+", "/", ":", ";", "<", "=", ">", "?", "[", "]", "^", "{", "|", "}", "~"]
    
    //MARK: - TITLES -
    static let titleLogin = "Login"
    static let titleHeroes = "Lista de Heroes"
    static let titleHeroesAllMap = "Busca tu Heroe"
    static let titleDetail = "Detalle"
    //MARK: - BUTTON NAME -
    static let butonLogOut = "LogOut"
    static let backButton = "Atras"
    
}

extension Notification.Name {
    static let showAlertEmailorPassword = Notification.Name("showAlertErrorUserDates")
    static let showAlertErrorNetwork = Notification.Name("showAlertErrorNetwork")
    static let goToHeroes = Notification.Name("goToHeroes")
}


// NETWORK
extension NotificationCenter{
    static let apiLoginNotification = Notification.Name("NOTIFICATION_API_LOGIN")
    static let tokenKey = "KEY_TOKEN"
    static let api_response = "API_RESPONSE"
}
