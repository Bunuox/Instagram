//
//  FeedVC.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import UIKit
import SDWebImage

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postsFeedTableView: UITableView!
    var postsArray: [PostData] = []
    var documentIdArray : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        postsFeedTableView.delegate = self
        postsFeedTableView.dataSource = self
        
        let post = Post()
        post.getPostsFromFirestore { message, postsArray, documentIdArray in
            self.postsArray.removeAll(keepingCapacity: false)
            self.documentIdArray.removeAll(keepingCapacity: false)
            print(message)
            self.postsArray = postsArray
            self.documentIdArray = documentIdArray
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
        cell.postImageView.sd_setImage(with: URL(string: postsArray[indexPath.row].imageURL))
        cell.postDocumentId = documentIdArray[indexPath.row]
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.postsFeedTableView.rowHeight = 481
    }

}
