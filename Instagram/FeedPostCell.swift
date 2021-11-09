//
//  FeedPostCell.swift
//  Instagram
//
//  Created by Bünyamin Kılıçer on 5.10.2021.
//

import UIKit

class FeedPostCell: UITableViewCell{
    
    @IBOutlet weak var userMailTextField: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postLikesTextField: UILabel!
    @IBOutlet weak var postLikeButton: UIButton!
    @IBOutlet weak var postUserCommentTextField: UILabel!
    
    var postDocumentId : String = ""
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        
        if self.postLikeButton.currentImage == UIImage(systemName: "heart.fill"){
            let post = Post()
            DispatchQueue.main.async {
                post.dislikePost(documentId: self.postDocumentId, currentLike: Int(self.postLikesTextField.text!)!) { error in
                    
                    if error != "" {
                        print("Something happened.")
                    }
                }
            }
            self.postLikeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
        
        else{
            let post = Post()
            
            DispatchQueue.main.async {
                post.likePost(documentId: self.postDocumentId, currentLike: Int(self.postLikesTextField.text!)!) { error in
                    
                    if error != "" {
                        print("Something happened.")
                    }
                }
            }
  
            self.postLikeButton.setImage(UIImage(systemName: "heart.fill"),for: .normal)
        }
    }
}
