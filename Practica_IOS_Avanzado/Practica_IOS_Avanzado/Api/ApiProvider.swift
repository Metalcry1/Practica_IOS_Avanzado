//
//  ApiProvider.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 15/11/23.
//

import UIKit

protocol ApiProviderProtocol{
    func login(for user: String, with password: String)
    func getHeroes(by name: String?, token: String, completion: ((Heroes) -> Void)?)
    func getLocations(by heroId: String?, token: String, completion: ((HeroLocations) -> Void)?)
    
}

class ApiProvider: ApiProviderProtocol {
    
    // MARK: - CONSTANTS -
    let keyChain = KeyChain()
    static private let apiBaseURL = "https://dragonball.keepcoding.education/api"
    private enum Endpoint {
        static let login = "/auth/login"
        static let heroes = "/heros/all"
        static let locations = "/heros/locations"
    }
    var token: String? = "TOKEN"
    
    
    //MARK: - LOGIN -
    func login(for user: String, with password: String) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.login)") else {
            // TODO: Enviar notificación indicando el error
            return
        }
        
        guard let loginData = String(format: "%@:%@",
                                     user, password).data(using: .utf8)?.base64EncodedString() else {
            // TODO: Enviar notificación indicando el error
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Basic \(loginData)",
                            forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                
                // TODO: Enviar notificación indicando el error
                var response: String?
                
                if let error = error {
                    switch error {
                    case let urlError as URLError:
                        switch urlError.code {
                        case .networkConnectionLost:
                            response = "Se perdió la conexión de red."
                        case .notConnectedToInternet:
                            response = "No hay conexión a Internet."
                        case .cannotConnectToHost:
                            response = "No se puede conectar al host."
                        case .timedOut:
                            response = "La solicitud ha excedido el tiempo de espera."
                        default:
                            response = "Error de red: \(urlError.localizedDescription)"
                        }
                    default:
                        response = "Error desconocido: \(error.localizedDescription)"
                    }
                }
                
                NotificationCenter.default.post(
                    name: NotificationCenter.apiLoginNotification,
                    object: nil,
                    userInfo: ["API_RESPONSE": "\(String(describing: response))"]
                )
                return
            }
            
            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                // TODO: Enviar notificación indicando response error
                
                let httpResponse = response as? HTTPURLResponse
                let statusCode = httpResponse?.statusCode ?? 0
                var response: String
                
                switch statusCode {
                case 100...199:
                    response = "Respuesta Informativa: \(statusCode)"
                case 200...299:
                    response = "Respuesta Exitosa: \(statusCode)"
                case 300...399:
                    response = "Redirección: \(statusCode)"
                case 400...499:
                    response = "Error del Cliente: \(statusCode)"
                case 500...599:
                    response = "Error del Servidor: \(statusCode)"
                default:
                    response = "Código de Estado Desconocido: \(statusCode)"
                }
                
                NotificationCenter.default.post(
                    name: NotificationCenter.apiLoginNotification,
                    object: nil,
                    userInfo: ["API_RESPONSE": "\(String(describing: response))"]
                )
                return
            }
            
            guard let token = String(data: data, encoding: .utf8) else {
                // TODO: Enviar notificación indicando response vacío
                return
            }
            
            self.token = token
            
            if !token.isEmpty{
                self.keyChain.save(token: token)
            }
            
            NotificationCenter.default.post(
                name: NotificationCenter.apiLoginNotification,
                object: nil,
                userInfo: ["API_RESPONSE": "\(String(describing: token))"]
            )
            
        }.resume()
    }
    
    //MARK: - GET HEROES -
    func getHeroes(by name: String?, token: String, completion: ((Heroes) -> Void)?) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.heroes)") else {
            // TODO: Enviar notificación indicando el error
            return
        }

        let jsonData: [String: Any] = ["name": name ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)",
                            forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion?([])
                return
            }

            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                // TODO: Enviar notificación indicando response error
                completion?([])
                return
            }

            guard let heroes = try? JSONDecoder().decode(Heroes.self, from: data) else {
                // TODO: Enviar notificación indicando response error
                completion?([])
                return
            }
            
            completion?(heroes)
        }.resume()
    }

    //MARK: - GET LOCATIONS HERO -
    
    func getLocations(by heroId: String?, token: String, completion: ((HeroLocations) -> Void)?) {
        guard let url = URL(string: "\(ApiProvider.apiBaseURL)\(Endpoint.locations)") else {
            // TODO: Enviar notificación indicando el error
            return
        }

        let jsonData: [String: Any] = ["id": heroId ?? ""]
        let jsonParameters = try? JSONSerialization.data(withJSONObject: jsonData)

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8",
                            forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(token)",
                            forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonParameters

        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                completion?([])
                return
            }

            guard let data,
                  (response as? HTTPURLResponse)?.statusCode == 200 else {
                completion?([])
                return
            }

            guard let heroLocations = try? JSONDecoder().decode(HeroLocations.self, from: data) else {
                completion?([])
                return
            }

//            print("API RESPONSE - GET HERO LOCATIONS: \(heroLocations)")
            completion?(heroLocations)
        }.resume()
    }
}

