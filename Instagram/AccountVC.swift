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
    var currentUser = Auth.auth().currentUser
    var userPosts = Array<PostData>()
    let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCurrentUserData()
        loadUserPosts()
        
        self.userPostTableView.delegate = self
        self.userPostTableView.dataSource = self

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
    
    func loadCurrentUserData(){
        
        if searchedUser?.userName != nil {
            self.userNameTextField.text = searchedUser!.userName
            self.mailTextField.text = searchedUser!.email
            self.sexTextField.text = searchedUser!.sex
        }
        
        self.user.getUserInfo(userId: currentUser!.uid) { userData, err in
            if err == nil{
                self.userNameTextField.text = userData!.userName
                self.mailTextField.text = userData!.email
                self.sexTextField.text = userData!.sex
            
            }
        }
    }
    
    func loadUserPosts(){
        let post = Post()
        if searchedUser?.userName == nil {
            post.getPostsByUserId(userId: self.currentUser!.uid) { posts, message in
                if message == "Success"{
                    self.userPosts.removeAll(keepingCapacity: false)
                    self.userPosts = posts
                    self.userPostTableView.reloadData()
                    }
                }

        }else{
            post.getPostsByUserId(userId: self.searchedUser!.userId){ posts, message in
                if message == "Success"{
                    self.userPosts.removeAll(keepingCapacity: false)
                    self.userPosts = posts
                    self.userPostTableView.reloadData()
                    
                    self.logoutButton.isHidden = true
                    self.userNameTextField.text = self.searchedUser?.userName
                    self.sexTextField.text = self.searchedUser?.sex
                    self.mailTextField.text = self.searchedUser?.email
                    
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.userPostTableView.rowHeight = 481
    }
    
}
