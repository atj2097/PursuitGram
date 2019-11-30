//
//  ViewController.swift
//  PursuitGram
//
//  Created by God on 11/26/19.
//  Copyright © 2019 God. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDelegates()
        // Do any additional setup after loading the view.
        
    }
 
    
    //MARK: Obj-C methods
    func setUpDelegates() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(validateFields), for: .editingChanged)
        loginButton.addTarget(self, action: #selector(tryLogin), for: .touchUpInside)
    }
    @objc func validateFields() {
        guard emailTextField.hasText, passwordTextField.hasText else {
        
            loginButton.isEnabled = false
            return
        }
        loginButton.isEnabled = true
    }
    
    @objc func showSignUp() {
        let signupVC = SignUpViewController()
        signupVC.modalPresentationStyle = .formSheet
        present(signupVC, animated: true, completion: nil)
    }
    
    @objc func tryLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(with: "Error", and: "Please fill out all fields.")
            return
        }
        
        //MARK: TODO - remove whitespace (if any) from email/password
        
        guard email.isValidEmail else {
            showAlert(with: "Error", and: "Please enter a valid email")
            return
        }
        
        guard password.isValidPassword else {
            showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
            return
        }
        
       FirebaseAuthService.manager.loginUser(email: email.lowercased(), password: password) { (result) in
            self.handleLoginResponse(with: result)
        }
    }
    
    //MARK: Private methods
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func handleLoginResponse(with result: Result<(), Error>) {
        switch result {
        case .failure(let error):
            showAlert(with: "Error", and: "Could not log in. Error: \(error)")
        case .success:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                else {
                    return
            }
            UIView.transition(with: self.view, duration: 0.1, options: .transitionFlipFromBottom, animations: {
                sceneDelegate.window?.rootViewController = PursuitGramTabBarVC()
            }, completion: nil)
        }
    }
    

}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

