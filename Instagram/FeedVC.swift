//
//  FeedVC.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import UIKit
import SDWebImage
import Firebase

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postsFeedTableView: UITableView!
    var postsArray: [PostData] = []
    var documentIdArray : [String] = []
    var userDetails = UserData()
    let user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postsFeedTableView.delegate = self
        postsFeedTableView.dataSource = self
        
        getAllPosts()
    }
    
    func getAllPosts(){
        
        let post = Post()
        post.getAllPosts { message, postsArray, documentIdArray in
            
            if message == nil && postsArray.isEmpty == false{
                self.postsArray.removeAll(keepingCapacity: false)
                self.documentIdArray.removeAll(keepingCapacity: false)

                self.postsArray = postsArray
                self.documentIdArray = documentIdArray
                self.postsPostedByChange(postsArray: postsArray)
                self.postsFeedTableView.reloadData()
            }
        }
    }
    
    func postsPostedByChange(postsArray : [PostData]){
        
        for i in 0 ... postsArray.count-1{
            user.getUserInfo(userId: postsArray[i].postedBy) { userData, err in
                if err == nil {
                    self.postsArray[i].postedBy = userData!.userName
                    self.postsFeedTableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPostCell", for: indexPath) as! FeedPostCell
        cell.postUserCommentTextField.text = postsArray[indexPath.row].comment
        cell.userMailTextField.text = postsArray[indexPath.row].postedBy
        cell.postLikesTextField.text = String(postsArray[indexPath.row].postLikes)
        cell.postImageView.sd_setImage(with: URL(string: postsArray[indexPath.row].imageURL))
        cell.postDocumentId = documentIdArray[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.postsFeedTableView.rowHeight = 481
    }

}
