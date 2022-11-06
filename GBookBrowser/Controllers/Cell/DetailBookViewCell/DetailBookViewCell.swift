//
//  DetailBookViewCell.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import UIKit
// pods
import Kingfisher
import FSPagerView

class DetailBookViewCell: FSPagerViewCell {
    
    
    //MARK: - UI Elements
    
    @IBOutlet weak var mainImageView: UIImageView!
    

    //MARK: - Prepare
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        mainImageView.kf.cancelDownloadTask()
        mainImageView.image = nil
    }
    
    func prepareItem(_ urlString: String?) {
        if let urlLink = urlString, let url = URL(string: urlLink) {
            // download image
            mainImageView.kf.indicatorType = .activity
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let item):
                    self.mainImageView.image = item.image
                case .failure(_):
                    self.setDefaultValue()
                }
            }
        } else {
            setDefaultValue()
        }
    }
    
    /**
     Set default image 
     */
    private func setDefaultValue() {
        mainImageView.tintColor = .white
        mainImageView.image = UIImage(systemName: "book.closed")
    }
}
