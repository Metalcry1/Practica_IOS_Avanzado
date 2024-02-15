//
//  HeroesViewController.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 19/11/23.
//

import UIKit

protocol HeroesViewControllerDelegate{
    var heroesViewStateVar: ((HeroesViewState) -> Void)? { get set }
    var heroesCount: Int { get }
    func heroInd(index: Int)-> Hero?
    func onViewAppear()
    var loginViewModel: LoginViewControllerDelegate { get }
    func heroesDetailViewModel (index: Int) -> HeroesDetailViewControllerDelegate?
    var heroesAllMapViewModel: HeroesAllMapViewControllerDelegate { get }
    func deleteHeros()

}

enum HeroesViewState {
    case loading(_ isLoading: Bool)
    case updateData
}

final class HeroesViewController: UIViewController{
    
    //MARK: - VARIABLES -
    var viewModel: HeroesViewControllerDelegate?
    private let coreDataProvider = CoreDataProvider()
    //MARK: - OUTLETS -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    //MARK: - LIFECYCLE -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = Constants.titleHeroes

    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.hidesBackButton = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Constants.butonLogOut, style: .plain, target: self, action: #selector(logOut))
        initViews()
        stateSituation()
        viewModel?.onViewAppear()
        registerTV()
    }
    
    //MARK: - ACTION -
    
    @IBAction func logOut(_ sender: Any) {
        viewModel?.deleteHeros()
        navigateToLogin()

    }
    @IBAction func allHeroesButom(_ sender: Any) {

    }
    //MARK: - FUNTIONS -
    func registerTV(){
        tableView.register(
            UINib(nibName: HeroesViewCell.identifier, bundle: nil),
            forCellReuseIdentifier: HeroesViewCell.identifier
        )
    }
    
    func initViews(){
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func stateSituation() {
        viewModel?.heroesViewStateVar = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading(let isLoading):
                    self?.loadingView.isHidden = !isLoading
                    print("esta Cargando la vista en heroes")
                    
                case .updateData:
                    print("Recargo los heroes")
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier{
            
        case Constants.LoginSegue:
            guard segue.identifier == Constants.LoginSegue,
                  let loginViewController = segue.destination as? LoginViewController,
                  let loginViewModel  = viewModel?.loginViewModel else {return}
            loginViewController.viewModel = loginViewModel
            
        case Constants.DetailSegue:
            guard segue.identifier == Constants.DetailSegue,
                  let index = sender as? Int,
                  let heroesDetailViewController = segue.destination as? HeroesDetailViewController,
                  let heroesDetailViewModel = viewModel?.heroesDetailViewModel(index: index) else {return}
            heroesDetailViewController.viewModel = heroesDetailViewModel
            
        case Constants.HeroesAllMapSegue:
            guard segue.identifier == Constants.HeroesAllMapSegue,
                  let heroesAllMapViewController = segue.destination as? HeroesAllMapViewController,
                  let heroesAllMapViewModel = viewModel?.heroesAllMapViewModel else {return}
            heroesAllMapViewController.viewModel = heroesAllMapViewModel
        default:
            break
        }
    }
    
    func navigateToLogin(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ [weak self] in
            self?.performSegue(withIdentifier: Constants.LoginSegue,
                               sender: nil)
        }
    }
    func navigateToHeroesAllMap(){
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)){ [weak self] in
            self?.performSegue(withIdentifier: Constants.HeroesAllMapSegue,
                               sender: self)
        }
    }
    
}

extension HeroesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.heroesCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        HeroesViewCell.sizeCell
    }
    
    //Obtenemos el Heroe y del array y lo enviamos a la celda personaliazada
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeroesViewCell.identifier,for: indexPath) as? HeroesViewCell else {
            return UITableViewCell()
        }
        
        if let hero = viewModel?.heroInd(index: indexPath.row) {
            cell.updateView(
                name: hero.name,
                photo: hero.photo,
                description: hero.description
            )
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.DetailSegue , sender: indexPath.row)
    }
}
