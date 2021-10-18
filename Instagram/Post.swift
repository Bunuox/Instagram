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
    var documentId: String?
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
    
    func getAllPosts(completion: @escaping (_ message:String, _ postData: [PostData],[String])->Void){
        firestoreDatabase.collection("Posts").order(by: "postedDate", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                completion(error?.localizedDescription ?? "error",[],[])
            }
            else{
                if snapshot?.isEmpty != true && snapshot != nil{
                    var postList = Array<PostData>()
                    var docIdList = Array<String>()
                    for document in snapshot!.documents {
                        var postDataStruct : PostData! = PostData(postedBy: "", postedDate: "", imageURL: "", postLikes: 0, comment: "")

                        if let postLikes = document.get("postLikes") as? Int{
                            postDataStruct.postLikes = postLikes
                        }
                        
                        if let imageURL = document.get("imageURL" ) as? String{
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
                        
                        let documentId = document.documentID
                        docIdList.append(documentId)
                    }
                    
                    completion("succes",postList,docIdList)
                }
            }
        }
    }
    
    func getPostsByUserMail(userMail: String, completion: @escaping (_ posts:[PostData], _ message:String) -> Void){
        firestoreDatabase.collection("Posts").order(by: "postedDate", descending: true).whereField("postedBy", isEqualTo: userMail).addSnapshotListener { snapshot, error in
            
            if error != nil {
                completion([],error?.localizedDescription ?? "Error")
            }else{
                var postList = Array<PostData>()
                for document in snapshot!.documents {
                    var postDataStruct = PostData(postedBy: "", postedDate: "", imageURL: "", postLikes: 0, comment: "")
                    
                    if let postLikes = document.get("postLikes") as? Int{
                        postDataStruct.postLikes = postLikes
                    }
                    
                    if let imageURL = document.get("imageURL" ) as? String{
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
                    
                    postDataStruct.documentId = document.documentID
                    postList.append(postDataStruct)
                }
                
                completion(postList,"Success")
            }
        }
    }

    func likePost(documentId: String, currentLike: Int, completion: @escaping (_ error: String) -> Void){
        let newLikeCount = ["postLikes": currentLike+1] as [String:Any]
        firestoreDatabase.collection("Posts").document(documentId).setData(newLikeCount, merge: true, completion: { error in
            if error != nil{
                completion("Something happened")
            }else{
                completion("")
            }
        })
    }
    
    func dislikePost(documentId: String, currentLike: Int, completion: @escaping (_ error: String) -> Void){
        let newLikeCount = ["postLikes": currentLike-1] as [String:Any]
        firestoreDatabase.collection("Posts").document(documentId).setData(newLikeCount, merge: true, completion: { error in
            if error != nil{
                completion("Something happened")
            }
            else{
                completion("")
            }
        })
    }
}
