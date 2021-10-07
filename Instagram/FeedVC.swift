//
//  FeedVC.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postsFeedTableView: UITableView!
    var postsArray: [PostData] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        postsFeedTableView.delegate = self
        postsFeedTableView.dataSource = self
        
        let post = Post()
        post.getPostsFromFirestore { message, postsArray in
            print(message)
            self.postsArray = postsArray
            self.postsFeedTableView.reloadData()
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
        cell.postImageView.image = UIImage(named:"image")
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.postsFeedTableView.rowHeight = 481
    }

}
