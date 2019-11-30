//
//  FirebaseService.swift
//  PursuitGram
//
//  Created by God on 11/27/19.
//  Copyright © 2019 God. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FireStoreCollections: String {
    case users
    case posts
    case comments
}

class FirestoreService {
    static let manager = FirestoreService()
    
    private let db = Firestore.firestore()
    
    //MARK: AppUsers
    func createAppUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(user.fieldsDict) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
    
    func getAllUsers(completion: @escaping (Result<[AppUser], Error>) -> ()) {
        db.collection(FireStoreCollections.users.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let users = snapshot?.documents.compactMap({ (snapshot) -> AppUser? in
                    let userID = snapshot.documentID
                    let user = AppUser(from: snapshot.data(), id: userID)
                    return user
                })
                completion(.success(users ?? []))
            }
        }
    }
    
    //MARK: Posts
    func createPost(post: Post, completion: @escaping (Result<(), Error>) -> ()) {
        db.collection(FireStoreCollections.posts.rawValue).addDocument(data: post.fieldsDict) { (error) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func getAllPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
        db.collection(FireStoreCollections.posts.rawValue).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let posts = snapshot?.documents.compactMap({ (snapshot) -> Post? in
                    let postID = snapshot.documentID
                    let post = Post(from: snapshot.data(), id: postID)
                    return post
                })
                completion(.success(posts ?? []))
            }
        }
    }
    
    func getPosts(forUserID: String, completion: @escaping (Result<[Post], Error>) -> ()) {
    db.collection(FireStoreCollections.posts.rawValue).whereField("creatorID", isEqualTo: forUserID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let posts = snapshot?.documents.compactMap({ (snapshot) -> Post? in
                    let postID = snapshot.documentID
                    let post = Post(from: snapshot.data(), id: postID)
                    return post
                })
                completion(.success(posts ?? []))
            }
        }
        
    }
    
    //MARK: Comments
    
//    func createComment(comment: Comment, completion: @escaping (Result<(), Error>) -> ()) {
//        db.collection(FireStoreCollections.comments.rawValue).addDocument(data: comment.fieldsDict) { (error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                completion(.success(()))
//            }
//        }
//    }
//    
//    func getComments(forPostID: String, completion: @escaping (Result<[Comment], Error>) -> ()) {
//        db.collection(FireStoreCollections.comments.rawValue).whereField("postID", isEqualTo: forPostID).getDocuments { (snapshot, error) in
//            if let error = error {
//                completion(.failure(error))
//            } else {
//                let comments = snapshot?.documents.compactMap({ (snapshot) -> Comment? in
//                    let commentID = snapshot.documentID
//                    let comment = Comment(from: snapshot.data(), id: commentID)
//                    return comment
//                })
//                completion(.success(comments ?? []))
//            }
//        }
//    }
//        
//        func getComments(forUserID: String, completion: @escaping (Result<[Comment], Error>) -> ()) {
//            
//        }
//        
//        private init () {}
}

