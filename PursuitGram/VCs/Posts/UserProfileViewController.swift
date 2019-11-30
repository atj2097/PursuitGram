//
//  UserProfileViewController.swift
//  PursuitGram
//
//  Created by God on 11/27/19.
//  Copyright © 2019 God. All rights reserved.
//

import UIKit
import Photos
import Firebase
class UserProfileViewController: UIViewController {
    var user: AppUser!
    var isCurrentUser = false
    
    var posts = [Post]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var numberOfPosts: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        user = AppUser(from: FirebaseAuthService.manager.currentUser!)
        getPostsForThisUser()
        setUpViews()
        // Do any additional setup after loading the view.
    }
    func setUpViews()  {
        numberOfPosts.text = "\(posts.count)"
        emailText.text = user.email
    }

    private func getPostsForThisUser() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            FirestoreService.manager.getPosts(forUserID: self?.user.uid ?? "") { (result) in
                switch result {
                case .success(let posts):
                    self?.posts = posts
                case .failure(let error):
                    print(":( \(error)")
                }
            }
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}

extension UserProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.userPostCell.rawValue, for: indexPath) as! UserCell
        var currentPost = posts[indexPath.row]
        ImageHelper.shared.getImage(urlStr: currentPost.imageURL) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let imageFromOnline):
                    cell.userPost.image = imageFromOnline
                }
            }
        }
        return cell 
    }
    
    
}



