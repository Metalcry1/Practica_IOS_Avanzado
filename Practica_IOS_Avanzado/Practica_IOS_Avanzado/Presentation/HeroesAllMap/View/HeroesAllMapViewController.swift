//
//  HeroesAllMapViewController.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 23/11/23.
//

import UIKit
import MapKit
import Kingfisher

protocol HeroesAllMapViewControllerDelegate{
    var heroesViewModel: HeroesViewControllerDelegate { get }
    var loginViewModel: LoginViewControllerDelegate { get }
    func onViewAppear()
    var heroesAllMapviewState: ((HeroesAllMapViewState) -> Void)? {get set}
    func deleteHeros()
}

enum HeroesAllMapViewState {
    case loading(_ isLoading: Bool)
    case update(hero: Hero?, locations: HeroLocations)
}

final class HeroesAllMapViewController: UIViewController{
    
    var viewModel: HeroesAllMapViewControllerDelegate?
    
    
    //MARK: - OUTLETS -
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    //MARK: - LIFECYCLE -
    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.butonLogOut, style: .plain, target: self, action: #selector(logOut))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.backButton, style: .plain, target: self, action: #selector(navigateToHeroes))
        super.viewDidLoad()
        initViews()
        stateSituation()
        viewModel?.onViewAppear()
        self.title = Constants.titleHeroesAllMap
    }
    
    //MARK: -FUNCIONES-
    
    @objc func logOut(_ sender: Any) {
        viewModel?.deleteHeros()
        navigateToLogin()
    }
    
    func initViews(){
        mapView.delegate = self
    }
    
    private func stateSituation() {
        viewModel?.heroesAllMapviewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading
                case .update(hero: let hero, locations: let locations):
                    self?.updateViews(hero: hero, heroLocations: locations)
                    break
                }
            }
        }
    }
    
    private func updateViews(hero: Hero?, heroLocations: HeroLocations) {
        heroLocations.forEach { heroLocation in
            mapView.addAnnotation(
                HeroMapPoint(
                    title: hero?.name,
                    coordinate: .init(
                        latitude: Double(heroLocation.latitude ?? "") ?? 0.0,
                        longitude: Double(heroLocation.longitude ?? "") ?? 0.0
                    ),
                    info: hero?.id
                )
            )
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier{
            
        case Constants.LoginSegue:
            guard segue.identifier == Constants.LoginSegue,
                  let loginViewController = segue.destination as? LoginViewController,
                  let loginViewModel  = viewModel?.loginViewModel else {return}
            loginViewController.viewModel = loginViewModel
            
        case Constants.HeroesSegue:
            guard segue.identifier == Constants.HeroesSegue,
                  let heroesViewController = segue.destination as? HeroesViewController,
                  let heroesViewModel = viewModel?.heroesViewModel else {return}
            heroesViewController.viewModel = heroesViewModel

        default:
            break
        }
    }
    
    @objc func navigateToHeroes(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ [weak self] in
                self?.performSegue(withIdentifier: Constants.HeroesSegue,
                                   sender: nil)
            }
    }
    
    func navigateToLogin(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ [weak self] in
            self?.performSegue(withIdentifier: Constants.LoginSegue,
                               sender: nil)
        }
    }
    
}
    

    extension HeroesAllMapViewController: MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "MultipleHeroMapPoint"
            let annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: identifier
            ) ?? MKAnnotationView(
                annotation: annotation,
                reuseIdentifier: identifier
            )
            
            annotationView.canShowCallout = true
            if annotation is MKUserLocation {
                return nil
            } else if annotation is HeroMapPoint {
                // Resize image
                let pinImage: UIImage?
                pinImage = UIImage(named: "img_map_pin")
                let size = CGSize(width: 30, height: 30)
                UIGraphicsBeginImageContext(size)
                if pinImage != nil {
                    pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                }else{
                    pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
                }
                let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
                
                annotationView.image = resizedImage
                return annotationView
            } else {
                return nil
            }
        }
    }
