//
//  EditUserVC.swift
//  PursuitGram
//
//  Created by God on 11/30/19.
//  Copyright © 2019 God. All rights reserved.
//

import UIKit

class EditUserVC: UIViewController {
    var user: AppUser!
    
    var image = UIImage() {
        didSet {
            self.imageView.image = image
        }
    }
    
    var imageURL: URL? = nil
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var presentImagePicker: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBAction func saveChanges(_ sender: UIButton) {
        guard let userName = userNameTextField.text, let imageURL = imageURL else {
                   //MARK: TODO - alert
                   return
               }
               FirebaseAuthService.manager.updateUserFields(userName: userName, photoURL: imageURL) { (result) in
                   switch result {
                   case .success():
                       FirestoreService.manager.updateCurrentUser(userName: userName, photoURL: imageURL) { [weak self] (nextResult) in
                           switch nextResult {
                           case .success():
                               let pastVC = UserProfileViewController()
                               self?.present(pastVC, animated: true, completion: nil)
                           case .failure(let error):
                               //MARK: TODO - handle
                               
                               //Discussion - if can't update on user object in collection, our firestore object will not match what is in auth. should we:
                               // 1. Re-try the save?
                               // 2. Revert the changes on the auth user?
                               // This reconciliation should all be handled on the server side, but having to handle here, we could run into an infinite loop when re-saving.
                               print(error)
                           }
                       }
                   case .failure(let error):
                       //MARK: TODO - handle
                       print(error)
                   }
               }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        FirebaseAuthService.manager.logoutUser()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        user = AppUser(from: FirebaseAuthService.manager.currentUser!)

        // Do any additional setup after loading the view.
    }
    
 
    
}
