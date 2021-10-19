//
//  ViewController.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Recognizer For Hide Keyboard
        let hideKeyboardGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardGestureRecognizer)
    }

    @IBAction func signUpButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpVC", sender: nil)
    }
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != ""{
            let user = User()
            user.userSignIn(userData: .init(email: emailTextField.text!, password: passwordTextField.text!)) { message in
                
                if message != "success" {
                    self.makeAlert(title: "Error", message: message)
                }
                
                else{
                    self.performSegue(withIdentifier: "toAppContentVC", sender: nil)
                }
            }
        }else{
            self.makeAlert(title: "Error", message: "Please fill fields")
        }
    }
    
    func makeAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
}

