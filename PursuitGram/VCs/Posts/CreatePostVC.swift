//
//  CreatePost.swift
//  PursuitGram
//
//  Created by God on 11/27/19.
//  Copyright © 2019 God. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary
import FirebaseStorage
import Firebase
import Kingfisher


class CreatePostVC: UIViewController {
    var image = UIImage() {
        didSet {
            self.imageUpload.image = image
        }
    }
    var imageURL: URL? = nil
    
    @IBOutlet weak var imageUpload: UIImageView!
    @IBOutlet weak var createPostButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func imagePickerFunc(_ sender: Any) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        present(imagePickerVC, animated: true)
    }
    
    @IBAction func createPost(_ sender: UIButton) {
        guard imageUpload.image != nil else {
            showAlert(with: "Error", and: "Please enter a valid image")
            return
        }
        guard let currentUser = FirebaseAuthService.manager.currentUser else {
            showAlert(with: "Error", and: "You must be logged in to create a post")
            return
        }
         guard let imageURLString = imageURL?.absoluteString else {
                   return
               }
        let newPost = Post(creatorID: currentUser.uid, image: imageURLString, userName: currentUser.email!)
        FirestoreService.manager.createPost(post: newPost) { (result) in
            self.handlePostResponse(withResult: result)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: Private methods
    private func handlePostResponse(withResult result: Result<Void, Error>) {
        switch result {
        case .success:
            
            let alertVC = UIAlertController(title: "Yay", message: "New post was added", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { [weak self] (action)  in
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            }))
            present(alertVC, animated: true, completion: nil)
        case let .failure(error):
            print("An error occurred creating the post: \(error)")
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
extension CreatePostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
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
                //Note - defer UI response, update user image url in auth and in firestore when save is pressed
                self?.imageURL = url
            case .failure(let error):
                print(error)
            }
        })
        dismiss(animated: true, completion: nil)
    }
}
