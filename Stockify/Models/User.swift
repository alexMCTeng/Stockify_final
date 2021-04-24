//
//  User.swift
//  Cameo
//
//  Created by Ege Çavuşoğlu on 11/8/20.
//  Copyright © 2020 Ege Çavuşoğlu. All rights reserved.
//

import Foundation
import FirebaseDatabase

class User {
    
    static let shared = User()
    
    var ref = Database.database().reference()
    
    
    
    
    init() {
        
    }
    
    func addToFavorites(name: String) -> Bool{
        
        if (getLoginStatus()){
                 ref.child("/users/\(getUserId())/favorites/\(name)").setValue(name)
            return true
        }
        else{
            return false
        }
        
        
    }
    
    func removeFavorite(name: String) -> Bool {
        
        ref.child("/users/\(getUserId())/favorites/\(name)").removeValue()
        
        return true
    }
    
    
}
