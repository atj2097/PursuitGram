//
//  SignUpViewController.swift
//  PursuitGram
//
//  Created by God on 11/27/19.
//  Copyright © 2019 God. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @objc func validateFields() {
        guard emailTextField.hasText, passwordTextField.hasText,  userNameTextField.hasText else {
            createButton.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 0.5)
            createButton.isEnabled = false
            return
        }
        createButton.isEnabled = true
        createButton.backgroundColor = UIColor(red: 255/255, green: 67/255, blue: 0/255, alpha: 1)
    }
    
    @objc func trySignUp() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(with: "Error", and: "Please fill out all fields.")
            return
        }
        
        guard email.isValidEmail else {
            showAlert(with: "Error", and: "Please enter a valid email")
            return
        }
        
        guard password.isValidPassword else {
            showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
            return
        }
        
        guard userNameTextField.hasText else {
            showAlert(with: "Error", and: "Please enter a valid user name.")
            return
        }
        
        FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password) { [weak self] (result) in
            self?.handleCreateAccountResponse(with: result)
        }
    }
    
    //MARK: Private methods
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func handleCreateAccountResponse(with result: Result<User, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let user):
                
                //MARK: TODO - move this logic to the server
                FirestoreService.manager.createAppUser(user: AppUser(from: user)) { [weak self] newResult in
                    self?.handleCreatedUserInFirestore(result: newResult)
                }
            case .failure(let error):
                self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
            }
        }
    }
    
    private func handleCreatedUserInFirestore(result: Result<Void, Error>) {
        switch result {
        case .success:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                else {
                    self.dismiss(animated: true, completion: nil)
                    return
            }
            
            UIView.transition(with: self.view, duration: 0.1, options: .transitionFlipFromBottom, animations: {
                sceneDelegate.window?.rootViewController = PursuitGramTabBarVC()
            }, completion: nil)
        case .failure(let error):
            self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
