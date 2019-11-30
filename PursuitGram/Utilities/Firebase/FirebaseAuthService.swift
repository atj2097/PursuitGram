//
//  FirebaseAuthService.swift
//  PursuitGram
//
//  Created by God on 11/27/19.
//  Copyright © 2019 God. All rights reserved.
//

import Foundation
import FirebaseAuth

class FirebaseAuthService {
    static let manager = FirebaseAuthService()
    
    private let auth = Auth.auth()

    var currentUser: User? {
        return auth.currentUser

    }
    
    func createNewUser(email: String, password: String, completion: @escaping (Result<User,Error>) -> ()) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let createdUser = result?.user {
                completion(.success(createdUser))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> ()) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let user = result?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    private init () {}
}
