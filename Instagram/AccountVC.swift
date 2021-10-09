//
//  AccountVC.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountVC: UIViewController {

    @IBOutlet weak var userNameTextField: UILabel!
    @IBOutlet weak var sexTextField: UILabel!
    @IBOutlet weak var mailTextField: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = User()
        user.getCurrentUserInfo { userData, err in
            if err != nil {
                print(err ?? "Error")
            }else{
                self.userNameTextField.text = userData?.userName
                self.sexTextField.text = userData?.sex
                self.mailTextField.text = userData?.email
            }
        }
    }

    @IBAction func logoutButtonClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        }catch{
            print("Something happened.")
        }
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
}
