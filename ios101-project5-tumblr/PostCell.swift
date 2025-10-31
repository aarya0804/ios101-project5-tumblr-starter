//
//  PostCell.swift
//  ios101-project5-tumblr
//
//  Created by Aarya Awasthy on 10/29/25.
//

import UIKit

class PostCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        summaryLabel.numberOfLines = 0
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        summaryLabel.text = nil
    }

}
