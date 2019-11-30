//
//  UserProfileViewController.swift
//  PursuitGram
//
//  Created by God on 11/27/19.
//  Copyright © 2019 God. All rights reserved.
//

import UIKit
import Photos

class UserProfileViewController: UIViewController {
    var user: AppUser!
    var isCurrentUser = false
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var numberOfPosts: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var userNameTextField: UITextField!

    @IBOutlet weak var editEmailTextField: UITextField!
    
    @IBAction func changeProfilePic(_ sender: Any) {
    }
    @IBAction func editProfilePic(_ sender: Any) {
        userNameTextField.isHidden = false
        editEmailTextField.isHidden = false
        
        setUpViews()
    }
    @IBOutlet weak var editProfile: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        userNameTextField.isHidden = true
        editEmailTextField.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    func setUpViews()  {
        //TO DO: Set up profilePic
        userNameLabel.text = user.userName
        emailText.text = user.email
    }
}



extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
        return
    }
    if let asset = info[UIImagePickerController.InfoKey.phAsset] as? PHAsset{
        if let fileName = asset.value(forKey: "filename") as? String{
         
        }
    }
}
}
