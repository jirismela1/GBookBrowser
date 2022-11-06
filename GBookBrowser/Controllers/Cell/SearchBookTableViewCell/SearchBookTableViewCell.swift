//
//  SearchBookTableViewCell.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import UIKit
// pods
import Kingfisher

class SearchBookTableViewCell: UITableViewCell {

    
    //MARK: - UI Elements
    
    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    
    //MARK: - Awake
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainBackgroundView.layer.cornerRadius = 10
        mainBackgroundView.layer.masksToBounds = true
    }
    
    
    //MARK: - Prepare
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        authorLabel.text = nil
        
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
    }
    
    func prepareItem(_ data: BookData?) {
        // prepare text
        titleLabel.text = data?.title
        authorLabel.text = data?.authors?.joined(separator: ",")
        
        // download image
        thumbnailImageView.kf.indicatorType = .activity
        if let urlLink = data?.imageLinks?.getImageLink(), let url = URL(string: urlLink) {
            thumbnailImageView.contentMode = .scaleAspectFill
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let item):
                    self.thumbnailImageView.image = item.image
                case .failure(_):
                    self.setDefaultImage()
                }
            }
        } else {
            setDefaultImage()
        }
    }
    
    /**
     Set default image
     */
    private func setDefaultImage() {
        thumbnailImageView.contentMode = .center
        thumbnailImageView.image = UIImage(named: "book_placeholder")
    }
}
