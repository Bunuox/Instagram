//
//  UploadVC.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import UIKit
import Firebase
import FirebaseStorage

class UploadVC: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    var imageURL: URL!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Image Recognizer
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
        //Hide Keyboard Recognizer
        let hideKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.imageView.image = UIImage(named: "image")
        self.commentTextField.text = ""
    }

    @IBAction func postButtonClicked(_ sender: Any) {
        let post = Post()
        post.uploadPost(image: imageView.image, storeRefName: "Images", imageURL: self.imageURL) { storageMetadata, imageUrl in
            
            if storageMetadata != "" && imageUrl != ""{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let date = Date()
                let dateString = dateFormatter.string(from: date)
                
                post.createPostDocument(postData: .init(postedBy: Auth.auth().currentUser!.uid, postedDate: dateString, imageURL: imageUrl, postLikes: 0,comment: self.commentTextField.text!)){
                    errorMessage in
                    
                    if errorMessage == ""{
                        
                        self.makeAlert(title: "Success", message: "Post successfully uploaded")
                    }
                    
                    else{
                        self.makeAlert(title: "Errr", message: "Something Happened.")
                    }
                }
                
            }else{
                self.makeAlert(title: "Error", message: "Error when posting photo.")
            }
        }
    }
    
    @objc func chooseImage(){
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.imageURL = info[.imageURL] as? URL
        self.dismiss(animated: true, completion: nil)
    }
     
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    func makeAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
}

