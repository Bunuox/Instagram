//
//  AccountVC.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class AccountVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var userNameTextField: UILabel!
    @IBOutlet weak var sexTextField: UILabel!
    @IBOutlet weak var mailTextField: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userPostTableView: UITableView!
    
    var searchedUser : UserData?
    var userPosts = Array<PostData>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userPostTableView.delegate = self
        self.userPostTableView.dataSource = self

        let user = User()
        let currentUserId = Auth.auth().currentUser?.uid
        if searchedUser?.userName == ""{
            user.getUserInfo(userId: currentUserId!){ userData, err in
                if err != nil {
                    print(err ?? "Error")
                }else{
                    self.userNameTextField.text = userData?.userName
                    self.sexTextField.text = userData?.sex
                    self.mailTextField.text = userData?.email
                }
            }
        }
        else{
            self.logoutButton.isHidden = true
            self.userNameTextField.text = searchedUser?.userName
            self.sexTextField.text = searchedUser?.sex
            self.mailTextField.text = searchedUser?.email
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPostCell", for: indexPath) as! FeedPostCell
        cell.postUserCommentTextField.text = userPosts[indexPath.row].comment
        cell.postLikesTextField.text = String(userPosts[indexPath.row].postLikes)
        cell.postImageView.sd_setImage(with: URL(string: userPosts[indexPath.row].imageURL))
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let post = Post()
        if searchedUser?.userName == ""{
            post.getPostsByUserMail(userMail: userNameTextField.text!) { posts, message in
                if message == "Success"{
                    self.userPosts.removeAll(keepingCapacity: false)
                    self.userPosts = posts
                    self.userPostTableView.reloadData()
                }
            }
        }else{
            post.getPostsByUserMail(userMail: searchedUser!.email) { posts, message in
                if message == "Success"{
                    self.userPosts.removeAll(keepingCapacity: false)
                    self.userPosts = posts
                    self.userPostTableView.reloadData()
                }
            }
        }
        self.userPostTableView.rowHeight = 481
    }
}
