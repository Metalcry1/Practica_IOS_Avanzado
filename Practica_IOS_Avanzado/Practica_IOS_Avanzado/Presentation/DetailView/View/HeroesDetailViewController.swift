//
//  HeroesDetailViewController.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 22/11/23.
//

import UIKit
import MapKit
import Kingfisher

protocol HeroesDetailViewControllerDelegate{
    var heroesDetailViewStateVar: ((HeroesDetailViewState) -> Void)? { get set }
    func onViewAppear()
    var heroesViewModel: HeroesViewControllerDelegate { get }
    var loginViewModel: LoginViewControllerDelegate { get }
    func deleteHeros()
}

enum HeroesDetailViewState {
    case loading(_ isLoading: Bool)
    case updateData(hero: Hero?, locations: [HeroMapPoint]?)
}

final class HeroesDetailViewController: UIViewController{
    
    var viewModel: HeroesDetailViewControllerDelegate?
    
    
    //MARK: - OUTLETS -
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var heroDescription: UITextView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    
    //MARK: - ACTIONS -


    //MARK: - LIFECYCLE -
    override func viewDidLoad() {

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.butonLogOut, style: .plain, target: self, action: #selector(logOut))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: Constants.backButton, style: .plain, target: self, action: #selector(navigateToHeroes))
        super.viewDidLoad()
        initViews()
        stateSituation()
        viewModel?.onViewAppear()
        self.title = Constants.titleDetail
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: -FUNCIONES-
    
    @objc func logOut(_ sender: Any) {
        viewModel?.deleteHeros()
        navigateToLogin()

    }
    
    func initViews(){
        mapView.delegate = self
    }
    func stateSituation() {
        viewModel?.heroesDetailViewStateVar = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                self?.loadingView.isHidden = !isLoading
                    print("esta Cargandoooo")
                    
                case .updateData(let hero, let heroLocations):
                    print("Actualizar datos tabla")
                    self?.updateViews(hero: hero, heroLocations: heroLocations)
                }
            }
        }
    }
    
    private func updateViews(hero: Hero?, heroLocations: [HeroMapPoint]?) {
        photo.kf.setImage(with: URL(string: hero?.photo ?? ""))
        makeRounded(image: photo)
        name.text = hero?.name
        heroDescription.text = hero?.description

        heroLocations?.forEach { mapView.addAnnotation($0) }
    }

    private func makeRounded(image: UIImageView) {
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        image.layer.cornerRadius = image.frame.height / 2
        image.layer.masksToBounds = false
        image.clipsToBounds = true
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
    
    @objc func navigateToLogin(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ [weak self] in
            self?.performSegue(withIdentifier: Constants.LoginSegue,
                               sender: nil)
        }
    }
}

extension HeroesDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "HeroAnnotation"
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
