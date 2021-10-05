//
//  FeedVC.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 2.10.2021.
//

import UIKit

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postsFeedTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        postsFeedTableView.delegate = self
        postsFeedTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPostCell", for: indexPath) as! FeedPostCell
        cell.postUserCommentTextField.text = "CommentText"
        cell.userMailTextField.text = "Mail"
        cell.postLikesTextField.text = "10"
        cell.postImageView.image = UIImage(named:"image")
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.postsFeedTableView.rowHeight = 481
    }

}
