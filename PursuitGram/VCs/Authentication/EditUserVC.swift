//
//  EditUserVC.swift
//  PursuitGram
//
//  Created by God on 11/30/19.
//  Copyright © 2019 God. All rights reserved.
//

import UIKit
import Photos
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
    @IBAction func presentPicker(_ sender: UIButton) {
        switch PHPhotoLibrary.authorizationStatus() {
        case .notDetermined, .denied, .restricted:
            PHPhotoLibrary.requestAuthorization({[weak self] status in
                switch status {
                case .authorized:
                    self?.presentPhotoPickerController()
                case .denied:
                    //MARK: TODO - set up more intuitive UI interaction
                    print("Denied photo library permissions")
                default:
                    //MARK: TODO - set up more intuitive UI interaction
                    print("No usable status")
                }
            })
        default:
            presentPhotoPickerController()
        }
    }
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
    private func presentPhotoPickerController() {
        DispatchQueue.main.async{
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            imagePickerViewController.mediaTypes = ["public.image"]
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
    }
    
 
    
}
extension EditUserVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            //MARK: TODO - handle couldn't get image :(
            return
        }
        self.image = image
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            //MARK: TODO - gracefully fail out without interrupting UX
            return
        }
        
        FirebaseStorageService.manager.storeUserInputImage(image: imageData, completion: { [weak self] (result) in
            switch result{
            case .success(let url):
                self?.imageURL = url
            case .failure(let error):
                //MARK: TODO - defer image not save alert, try again later. maybe make VC "dirty" to allow user to move on in nav stack
                print(error)
            }
        })
        dismiss(animated: true, completion: nil)
    }
}
