//
//  LoginViewController.swift
//  Practica_IOS_Avanzado
//
//  Created by Daniel Serrano on 15/11/23.
//

import UIKit

protocol LoginViewControllerDelegate{
    func botomLoginPress(email: String?, password: String?)
    var heroesViewModel: HeroesViewControllerDelegate { get }
    var loginViewState: ((LoginViewState) -> Void)? { get set }
}
enum LoginViewState {
    case loading(_ loading: Bool)
    case ErrorEmail(_ error: Bool)
    case ErrorPassword(_ error: Bool)
    case ErrorNetwork(_ error: Bool)
    case navigateToNext(_ navigate: Bool)
}

final class LoginViewController : UIViewController{
    
    // MARK: - OUTLETS -
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loadingView: UIView!
    var viewModel: LoginViewControllerDelegate?
    
    override func viewDidLoad() {
        navigationItem.hidesBackButton = true
        super.viewDidLoad()
        self.title = Constants.titleLogin
        myObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.loadingView.isHidden = false
    }
    
    // MARK: - ACTIONS -
    @IBAction func loginButomAction(_ sender: Any) {
        
        viewModel?.botomLoginPress(email: emailField.text, password: passwordField.text)
        
    }
    
    // MARK: - FUNTIONS -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.HeroesSegue,
              let heroesViewController = segue.destination as? HeroesViewController else {
            return
        }
        heroesViewController.viewModel = viewModel?.heroesViewModel
    }
    
   private func myObservers(){
        
       viewModel?.loginViewState = {[weak self] state in
           guard let self = self else { return }
           switch state{
           case .loading(let isLoading):
                   self.loadingView.isHidden = !isLoading
           case .ErrorEmail(true):
               NotificationCenter.default.addObserver(self, selector: #selector(handleShowAlertEmail), name: .showAlertEmailorPassword, object: nil)
           case .ErrorPassword(true):
               NotificationCenter.default.addObserver(self, selector: #selector(handleShowAlertPassword), name: .showAlertEmailorPassword, object: nil)
           case .ErrorNetwork(true):
               NotificationCenter.default.addObserver(self, selector: #selector(handleShowAlertErrorNetwork), name: .showAlertErrorNetwork, object: nil)
           case .navigateToNext(true):
               performSegue(withIdentifier: Constants.HeroesSegue,
                                  sender: nil)
           default:
               break
               
           }

       }
    }
    
    @objc func handleShowAlertEmail() {
        
        DispatchQueue.main.async {
            self.showAlert(title: "Error Email", message: "El correo no está correcto", LoginViewController: self)
        }
    }
    @objc func handleShowAlertPassword() {
        
        DispatchQueue.main.async {
            self.showAlert(title: "Error password", message: "El password no es correcto", LoginViewController: self)
        }
    }
    
    @objc func handleShowAlertErrorNetwork() {

        DispatchQueue.main.async {
            self.showAlert(title: "Error al Conectar", message: "Intenta conectar de nuevo", LoginViewController: self)
        }
    }
    
    
    func showAlert(title: String, message: String, LoginViewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alert.addAction(action)
        LoginViewController.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            alert.dismiss(animated: true)
        }
 
    }


}
