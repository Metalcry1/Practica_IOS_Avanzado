//
//  MockApiService.swift
//  Practica_IOS_AvanzadoTests
//
//  Created by Daniel Serrano on 10/12/23.
//

//
//  MockApiProvider.swift
//  DragonBallTests
//
//  Created by Gabriel Castro on 29/10/23.
//

import Foundation
@testable import Practica_IOS_Avanzado

class MockApiService: ApiProviderProtocol {
    
    private let responseToken: String = "eyJ0eXAiOiJKV1QiLCJraWQiOiJwcml2YXRlIiwiYWxnIjoiSFMyNTYifQ.eyJpZGVudGlmeSI6IkJGMUEwMTlDLUJGQUYtNDM4Ri05MEZELTc4RDY3QkQ5M0RCNyIsImVtYWlsIjoibWV0YWxjcnkxQGdtYWlsLmNvbSIsImV4cGlyYXRpb24iOjY0MDkyMjExMjAwfQ.nMioLT6CQI_lB8ehNB4MdGN4qaEuNaiIXXojo79mNbo"

    private let responseDataHeroes: [[String: Any]] = [
            [
                "id": "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3",
                "name": "Maestro Roshi",
                "description": "Es un maestro de artes marciales que tiene una escuela, donde entrenará a Goku y Krilin para los Torneos de Artes Marciales. Aún en los primeros episodios había un toque de tradición y disciplina, muy bien representada por el maestro. Pero Muten Roshi es un anciano extremadamente pervertido con las chicas jóvenes, una actitud que se utilizaba en escenas divertidas en los años 80. En su faceta de experto en artes marciales, fue quien le enseñó a Goku técnicas como el Kame Hame Ha",
                "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/Roshi.jpg?width=300",
                "favorite": false
            ],
            [
                "id": "1985A353-157F-4C0B-A789-FD5B4F8DABDB",
                "name": "Mr. Satán",
                "description": "Mr. Satán es un charlatán fanfarrón, capaz de manipular a las masas. Pero en realidad es cobarde cuando se da cuenta que no puede contra su adversario como ocurrió con Androide 18 o Célula. Siempre habla más de la cuenta, pero en algún momento del combate empieza a suplicar. Androide 18 le ayuda a fingir su victoria a cambio de mucho dinero. Él acepta el trato porque no podría soportar que todo el mundo le diera la espalda por ser un fraude.",
                "photo": "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/dragon-ball-satan.jpg?width=300",
                "favorite": false
                
            ]
    ]
    
    private let responseDataLocationHeroe: [[String: Any]] = [
        [
            "hero":
                [ "id": "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3"],
            "longitud": "-2.4746262",
            "dateShow": "2022-09-11T00:00:00Z",
            "id": "AB3A873C-37B4-4FDE-A50F-8014D40D94FE",
            "latitud": "36.8415268"
            ],
        [
            "hero":
                ["id": "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3"],
            "longitud": "-3.97",
            "dateShow": "2022-09-13T00:00:00Z",
            "id": "E7D32AAB-8846-40DB-BF08-F4AA82B915C5",
            "latitud": "40.43"
            ]
    ]
    required init(keychain: Practica_IOS_Avanzado.KeyChainProtocol) {}
    
    func getHeroes(by name: String?, token: String, completion: ((Practica_IOS_Avanzado.Heroes) -> Void)?) {
        do {
            let data = try JSONSerialization.data(withJSONObject: responseDataHeroes)
            let heroes = try? JSONDecoder().decode([Hero].self,
                                                   from: data)

            if let name {
                completion?(heroes?.filter { $0.name == name } ?? [])
            } else {
                completion?(heroes ?? [])
            }
        } catch {
            completion?([])
        }
    }
    
    func getLocations(by heroId: String?, token: String, completion: ((Practica_IOS_Avanzado.HeroLocations) -> Void)?) {
        do {
            let data = try JSONSerialization.data(withJSONObject: responseDataLocationHeroe)
            let heroLocations = try? JSONDecoder().decode([HeroLocation].self,
                                                   from: data)

            if let heroId {
                completion?(heroLocations?.filter{ $0.hero?.id == heroId } ?? [])
            } else {
                completion?(heroLocations ?? [])
            }
        } catch {
            completion?([])
        }
    }
    
    func login(for user: String, with password: String) {
        NotificationCenter.default.post(
            name: NotificationCenter.apiLoginNotification,
            object: nil,
            userInfo: [NotificationCenter.tokenKey: "MyTestToken"]
        )
    }
}
