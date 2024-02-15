//
//  ApiProviderTests.swift
//  Practica_IOS_AvanzadoTests
//
//  Created by Daniel Serrano on 10/12/23.
//

import Foundation
import XCTest
@testable import Practica_IOS_Avanzado

final class ApiProviderTests: XCTestCase {
    private var sut: ApiProviderProtocol!
    private var token: String = "Tokenfake"

    override func setUp() {
        sut = MockApiService(keychain: KeyChain())
    }

    func test_givenApiProvider_whenLoginWithUserAndPassword_thenGetValidToken() throws {
        let handler: (Notification) -> Bool = { notification in
            let token = notification.userInfo?[NotificationCenter.tokenKey] as? String
            XCTAssertNotNil(token)
            XCTAssertNotEqual(token ?? "", "")

            return true
        }

        let expectation = self.expectation(
            forNotification: NotificationCenter.apiLoginNotification,
            object: nil,
            handler: handler
        )

        sut.login(for: "metalcry1@gmail.com", with: "4312")
        wait(for: [expectation], timeout: 10.0)
    }

    func test_givenApiProvider_whenGetAllHeroes_ThenHeroesExists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")

        self.sut.getHeroes(by: nil, token: token) { heroes in
            XCTAssertNotEqual(heroes.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func test_givenApiProvider_whenGetOneHero_ThenHeroExists() throws {
        let expectation = self.expectation(description: "Maestro Roshi")
        
        let name = "Maestro Roshi"
        self.sut.getHeroes(by: name, token: token) { heroes in
            XCTAssertEqual(heroes.count, 1)
            XCTAssertEqual(heroes.first?.name ?? "Maestro Roshi", name)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10.0)
    }

    func test_givenApiProvider_whenGetOneHero_ThenHeroNotExists() throws {
        let expectation = self.expectation(description: "Fetch one hero data")

        let name = "MyHero"
        self.sut.getHeroes(by: name, token: token) { heroes in
            XCTAssertEqual(heroes.count, 0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_whenGetOneHero_ThenLocationsExists() throws {
        let expectation = self.expectation(description: "Fetch heroLocations data")
        let heroId = "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3"
        
        self.sut.getLocations(by: heroId, token: token) { heroLocations in
            XCTAssertEqual(heroLocations.count, 2)
            XCTAssertEqual(heroLocations.first?.latitude, "36.8415268")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
    
    func test_givenApiProvider_whenGetOneHero_ThenLocationsNotExists() throws {
        let expectation = self.expectation(description: "Fetch heroLocations data no exist")
        let heroId = "D13A40E5-4418-4223-9CE6-D2F9A28EBE945689984"
        
        self.sut.getLocations(by: heroId, token: token) { heroLocations in
            
            XCTAssertEqual(heroLocations.count, 0)
            XCTAssertEqual(heroLocations.first?.latitude, nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
