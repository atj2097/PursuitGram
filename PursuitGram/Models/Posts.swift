//
//  Posts.swift
//  PursuitGram
//
//  Created by God on 11/27/19.
//  Copyright © 2019 God. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Post {
    let creatorID: String
  
    let id :String
    let imageURL:String
    let userName:String
    
    init(creatorID: String, dateCreated: Date? = nil, image:String, userName:String) {
        self.creatorID = creatorID
  
         self.id = UUID().description
        self.imageURL = image
        self.userName = userName
    }
    
    init?(from dict: [String: Any], id: String) {
        guard let userID = dict["creatorID"] as? String,
            let image = dict["imageURL"] as? String,
            let userName = dict["userName"] as? String else { return nil }
        
        self.creatorID = userID

        self.id = id
        self.userName = userName
        self.imageURL = image
    }
    
    var fieldsDict: [String: Any] {
        return [
            "creatorID": self.creatorID,
            "userName": self.userName,
            "imageURL": self.imageURL
        ]
    }
}
