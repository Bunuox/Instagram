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

class Post{
    
    func uploadPost(image: UIImage?, storeRefName: String, imageURL: URL?, completion: @escaping (_ storageMetadata:String,_ imageUrl:String) -> Void){
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let imagesFolder = storageRef.child(storeRefName)
        
        if let data = image?.jpegData(compressionQuality: 0.5){
            
            //ImageRef Name Operations
            
            let randomStringForImagename = randomString(length: 12)
            var imageRefString = imageURL?.description ?? ("unknowImage" + randomStringForImagename) + ".jpg"
            let imageRefStringStartIndex = imageRefString.index(imageRefString.startIndex, offsetBy:96)
            imageRefString = String(imageRefString[imageRefStringStartIndex..<imageRefString.endIndex])
            
            //Yukarıda hamallık yapmışım, kolayı aşağıda:
            
            let imageRefRandom = UUID().uuidString
            
            let imageRef = imagesFolder.child("\(imageRefRandom).jpg")
            
            
            imageRef.putData(data, metadata: nil) { storageMetadata, storagePutError in
                
                if storagePutError != nil {
                    print(storagePutError?.localizedDescription)
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
    
    func randomString(length: Int) -> String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}
