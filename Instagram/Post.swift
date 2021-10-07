//
//  Post.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 3.10.2021.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage


struct PostData{
    var postedBy: String
    var postedDate: String
    var imageURL : String
    var postLikes: Int
    var comment: String
}

class Post{
    
    let firestoreDatabase = Firestore.firestore()
    var firestoreReference : DocumentReference? = nil
    
    func uploadPost(image: UIImage?, storeRefName: String, imageURL: URL?, completion: @escaping (_ storageMetadata:String,_ imageUrl:String) -> Void){
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesFolder = storageRef.child(storeRefName)
        
        if let data = image?.jpegData(compressionQuality: 0.5){
            
            //ImageRef Name Operations
            let imageRefRandom = UUID().uuidString
            let imageRef = imagesFolder.child("\(imageRefRandom).jpg")
            
            
            imageRef.putData(data, metadata: nil) { storageMetadata, storagePutError in
                
                if storagePutError != nil {
                    completion(storagePutError?.localizedDescription ?? "storagePutError","downloadUrlError")
                } else{
                    imageRef.downloadURL { url, downloadUrlError in
                        if downloadUrlError == nil{
                            completion(storageMetadata?.description ?? "",url?.absoluteString ?? "")
                        }
                    }
                }
            }
        }
    }
    
    func createPostDocument(postData: PostData, completion:@escaping (_ message: String) -> Void ){
        
        let documentPostData = ["imageURL":postData.imageURL, "postLikes":postData.postLikes, "postedDate":postData.postedDate, "postedBy":postData.postedBy,"comment": postData.comment] as [String : Any]
        
        firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: documentPostData, completion: { error in
            
            if error != nil {
                completion("Something Happened.")
            }
            
            else{
                completion("")
            }
        })
    }
    
    func getPostsFromFirestore(completion: @escaping (_ message:String, _ postData: [PostData])->Void){
        firestoreDatabase.collection("Posts").addSnapshotListener { snapshot, error in
            
            if error != nil{
                completion(error?.localizedDescription ?? "error",[])
            }
            else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    var postList = Array<PostData>()
                    for document in snapshot!.documents {
                        var postDataStruct : PostData! = PostData(postedBy: "", postedDate: "", imageURL: "", postLikes: 0, comment: "")
                        if let postLikes = document.get("postLikes") as? Int{
                            postDataStruct.postLikes = postLikes
                        }
                        
                        if let imageURL = document.get("imageURL") as? String{
                            postDataStruct.imageURL = imageURL
                        }
                        
                        if let postedDate = document.get("postedDate") as? String{
                            postDataStruct.postedDate = postedDate
                        }
                        
                        if let postedBy = document.get("postedBy") as? String{
                            postDataStruct.postedBy = postedBy
                        }
                        
                        if let comment = document.get("comment") as? String{
                            postDataStruct.comment = comment
                        }
                        
                        postList.append(postDataStruct)
                    }
                    
                    completion("succes",postList)
                }
            }
        }
        
    }
}
