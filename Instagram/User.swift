//
//  User.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import Foundation
import Firebase
import FirebaseAuth

class User{
    
    var email: String?
    var password: String?
    
    func userSingUp(email:String, password:String, completion: @escaping (String) -> Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { (AuthDataResult, error) -> Void in
            
            if error != nil {
                let success = error?.localizedDescription ?? "Error"
                completion(success)
            }
            else{
                let message = "success"
                completion(message)
            }
        }
        
    }
    
    func userSignIn(email:String, password:String, completion: @escaping (String) -> Void){
        
        Auth.auth().signIn(withEmail: email, password: password) { AuthDataResult, error in
            
            if error != nil{
                let errorMessage = error?.localizedDescription ?? "Error"
                completion(errorMessage)
            }
            else{
                completion("success")
            }
        }
    }
}
