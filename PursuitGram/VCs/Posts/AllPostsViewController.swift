//
//  AllPostsViewController.swift
//  PursuitGram
//
//  Created by God on 11/27/19.
//  Copyright © 2019 God. All rights reserved.
//

import UIKit
import Firebase
class AllPostsViewController: UIViewController {
    //Variables 
    var posts = [Post]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getPosts()
        // Do any additional setup after loading the view.
    }
    
    private func getPosts() {
        FirestoreService.manager.getAllPosts { (result) in
            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                print("error getting posts \(error)")
            }
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
extension AllPostsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier.timeLineCell.rawValue, for: indexPath) as! PostCell
        var currentPost = posts[indexPath.row]
        cell.postImage.loadImageUsingCacheWithUrlString(currentPost.imageURL)
        cell.postCreator.text = currentPost.creatorID
        return cell
    }
    
    
}
