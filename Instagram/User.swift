//
//  User.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import Foundation
import Firebase
import FirebaseAuth

struct UserData{
    
    var documentId : String?
    var userId: String!
    var userName : String!
    var email : String!
    var password: String!
    var sex: String!
}

class User{
    
    let firestoreDatabase = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil
    
    func userSingUp(userData: UserData, completion: @escaping (String) -> Void){
        
        Auth.auth().createUser(withEmail: userData.email!, password: userData.password!) { (AuthDataResult, error) -> Void in
            
            if error != nil {
                completion(error?.localizedDescription ?? "Error")
            }
            else{
                let userDocumentData = ["userName": userData.userName!,"email": userData.email!, "sex":userData.sex ?? "Not specified", "userId":AuthDataResult!.user.uid] as [String:Any]
                
                self.firestoreReference = self.firestoreDatabase.collection("Users").addDocument(data: userDocumentData, completion: { error in
                    
                    if error != nil{
                        completion(error?.localizedDescription ?? "Error")
                    }
                    else{
                        completion("success")
                    }
                })
            }
        }
        
    }
    
    func userSignIn(userData: UserData, completion: @escaping (String) -> Void){
        
        Auth.auth().signIn(withEmail: userData.email!, password: userData.password!) { AuthDataResult, error in
            
            if error != nil{
                let errorMessage = error?.localizedDescription ?? "Error"
                completion(errorMessage)
                
            }
            else{
                completion("success")
            }
        }
    }
    
    func getUserInfo(userId: String, completion: @escaping(_ userData: UserData?, _ err : String?) -> Void){
        let currentUser = Auth.auth().currentUser
        
        if currentUser != nil {
            
            let userId = userId
            firestoreDatabase.collection("Users").whereField("userId",isEqualTo: userId).addSnapshotListener { querySnapshot, error in
                
                if error != nil {
                    completion(nil,error?.localizedDescription ?? "")
                }
                else{
                    
                    var currentUserData = UserData()
                    if let currentUserId = querySnapshot!.documents[0].get("userId") as? String{
                        currentUserData.userId = currentUserId
                    }
                    
                    if let currentUserEmail = querySnapshot!.documents[0].get("email") as? String{
                        currentUserData.email = currentUserEmail
                    }
                    if let currentUserSex = querySnapshot!.documents[0].get("sex") as? String{
                        currentUserData.sex = currentUserSex
                    }
                    if let currentUserUserName = querySnapshot!.documents[0].get("userName") as? String{
                        currentUserData.userName = currentUserUserName
                    }
                    completion(currentUserData,nil)
                }
            }
        }
    }
    
    
    func getUsersBySearchText(searchText: String, completion: @escaping (_ users : [UserData] , _ message:String) -> Void){
        firestoreDatabase.collection("Users").whereField("userName", isEqualTo: searchText).addSnapshotListener { querySnapshot, error in
            
            if error != nil {
                completion([],error?.localizedDescription ?? "")
            }
            else{
                var userDataList = Array<UserData>()
                for document in querySnapshot!.documents{
                    var currentUserData = UserData.init()
                    var controlFlagForMultipleDoc = false
                    if let currentUserId = querySnapshot!.documents[0].get("userId") as? String{
                    currentUserData.userId = currentUserId
                        }
                    if let currentUserEmail = querySnapshot!.documents[0].get("email") as? String{
                    currentUserData.email = currentUserEmail
                        }
                    if let currentUserSex = querySnapshot!.documents[0].get("sex") as? String{
                    currentUserData.sex = currentUserSex
                        }
                    if let currentUserUserName = querySnapshot!.documents[0].get("userName") as? String{
                    currentUserData.userName = currentUserUserName
                        }
                
                    for userData in userDataList{
                        if userData.documentId == document.documentID{
                            controlFlagForMultipleDoc = true
                        }
                    }
                    
                    if controlFlagForMultipleDoc == false{
                        currentUserData.documentId = document.documentID
                        userDataList.append(currentUserData)
                    }
              }
                completion(userDataList,"Success")
            }
        }
    }
}
