//
//  SignUpVC.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import UIKit

class SignUpVC: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let hideKeyboardgestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideKeyboardgestureRecognizer)
    }

    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" && confirmPasswordTextField.text != "" {
            
            if passwordTextField.text == confirmPasswordTextField.text {
                
                let newUser = User()
                newUser.userSingUp(email: emailTextField.text!, password: passwordTextField.text!){ (data) -> Void in
                    
                    if data == "success"{
                        self.makeAlert(title: "Success", message: "User Created")
                    }
                    else{
                        self.makeAlert(title: "Error", message: data)
                    }
                }
                
            }
            
            else{
                makeAlert(title: "Error", message: "Please confirm password")
            }
            
        }
        
        else{
            
            makeAlert(title: "Error", message: "Please fill mandatory fields*")
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
