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
    
    var liked = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likeButtonClicked(_ sender: Any) {
        
        if(self.liked == 1) {
            self.postLikeButton.setImage(UIImage(systemName: "heart"),for: .normal)
            self.liked = 0
        }
        
        else{
            self.postLikeButton.setImage(UIImage(systemName: "heart.fill"),for: .normal)
            self.liked = 1
        }
    }
    

}
