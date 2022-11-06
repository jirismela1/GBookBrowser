//
//  DetailBookViewController.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 05.11.2022.
//

import UIKit
// pods
import FSPagerView
import Kingfisher

class DetailBookViewController: UIViewController {

    
    //MARK: - UI Elements
    
    @IBOutlet weak var pagerView: FSPagerView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundDimView: UIView!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    
    //MARK: - Properties
    
    private var selectedIndex = 0
    private var searchText: String?
    private var callback: ((_ addedNewItems: Bool, _ scrolledIndex: Int)->Void)?
    private var addedNewItems = false
    
    
    //MARK: - View methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // prepare
        prepareNavigationBar()
        changeBackgroundImage()
        setBlurEffect()
        
        // text
        descriptionTitleLabel.text = "book_detail_desription".localized
        navigationItem.title = "book_detail_title".localized
        
        // pagerView
        pagerView.itemSize = CGSize(width: view.bounds.size.width / 2, height: 80)
        pagerView.transformer = FSPagerViewTransformer(type: .overlap)
        pagerView.register(UINib(nibName: "DetailBookViewCell", bundle: nil), forCellWithReuseIdentifier: "DetailBookViewCell")
        pagerView.delegate = self
        pagerView.dataSource = self
        
        // scroll on item
        DispatchQueue.main.async {
            self.prepareView()
            self.pagerView.scrollToItem(at: self.selectedIndex, animated: false)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // callback
        callback?(addedNewItems, selectedIndex)
    }
    
    
    //MARK: - Functions
    
    /**
     Set new data to content
     */
    private func prepareView() {
        let data = BookDataSourceManager.shared().items[selectedIndex].data
        // description
        descriptionTextView.fadeTransition(0.2)
        self.descriptionTextView.text = data?.description ?? "book_detail_desription_is_empty".localized
        // title
        titleLabel.fadeTransition(0.2)
        titleLabel.text = data?.title
        // published date
        publishedDateLabel.fadeTransition(0.2)
        publishedDateLabel.text = data?.getPublishedYear()
        // enable right bar item
        navigationItem.rightBarButtonItem?.isEnabled = !(BookDataSourceManager.shared().items[selectedIndex].saleInfo?.buyLink == nil)
    }
    
    /**
     Change background image
     */
    private func changeBackgroundImage() {
        if let imageLink = BookDataSourceManager.shared().items[selectedIndex].data?.imageLinks?.getImageLink(), let url = URL(string: imageLink) {
            // download image
            KingfisherManager.shared.retrieveImage(with: url) { results in
                self.backgroundImageView.transitionCrossDissolveAnimation {
                    switch results {
                    case .success(let image):
                        self.backgroundImageView.image = image.image
                    case .failure(_):
                        self.backgroundImageView.image = nil
                    }
                }
            }
        } else {
            self.backgroundImageView.transitionCrossDissolveAnimation {
                self.backgroundImageView.image = nil
            }
        }
    }
    
    /**
     Set blurr above background image
     */
    private func setBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundDimView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundDimView.addSubview(blurEffectView)
    }
    
    /**
     Prepare navigation bar
     */
    private func prepareNavigationBar() {
        // right button item
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: #selector(buyBookAction(sender:)))
    }
    
    @objc func buyBookAction(sender: UIBarButtonItem) {
        if let linkString = BookDataSourceManager.shared().items[selectedIndex].saleInfo?.buyLink,
           let url = URL(string: linkString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    /**
     Returns controller
     
     - parameter selectedIndex:          Int
     
     - returns: UIViewController?
     */
    static func getController(_ selectedIndex: Int, searchText: String?, callback: ((_ addedNewItems: Bool, _ scrolledIndex: Int)->Void)?) -> UIViewController? {
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailBookViewController") as? DetailBookViewController {
            
            controller.searchText = searchText
            controller.callback = callback
            controller.selectedIndex = selectedIndex
            return controller
        }
        return nil
    }
}


//MARK: - FSPagerViewDataSource, FSPagerViewDelegate

extension DetailBookViewController: FSPagerViewDataSource, FSPagerViewDelegate {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return BookDataSourceManager.shared().items.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "DetailBookViewCell", at: index) as! DetailBookViewCell
        cell.prepareItem(BookDataSourceManager.shared().items[index].data?.imageLinks?.getImageLink())
        
        // "paging"
        if index == BookDataSourceManager.shared().items.count - 20, let searchText = self.searchText {
            _=BookDataSourceManager.shared().loadBooks(by: searchText) { success in
                if success {
                    // refresh pagerView
                    self.pagerView.reloadData()
                    self.addedNewItems = true
                }
            }
        }
        return cell
    }
    
    func pagerViewDidEndDecelerating(_ pagerView: FSPagerView) {
        // asign current index
        selectedIndex = pagerView.currentIndex
        // change new background image
        changeBackgroundImage()
        // refresh title and description
        prepareView()
    }
}

