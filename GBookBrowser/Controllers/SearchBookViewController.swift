//
//  ViewController.swift
//  GBookBrowser
//
//  Created by Jiří Šmela on 04.11.2022.
//

import UIKit
// pods
import Alamofire

class SearchBookViewController: UIViewController {
    
    
    //MARK: - UI Elements
    
    @IBOutlet weak var infoSearchView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoSearchVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: - Properties
    
    private let searchController = UISearchController()
    private var request: DataRequest?
    private var requestTimer: Timer?
    
    
    //MARK: - View Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        self.navigationController?.navigationBar.tintColor = UIColor.white
        prepareSearchController()
        
        // tableView
        tableView.register(UINib(nibName: "SearchBookTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchBookTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset.top = 5
        tableView.contentInset.bottom = 5
        
        // prepare
        activityIndicator.color = .white
        
        // text
        infoLabel.text = "search_book_info_label".localized
        navigationItem.title = "search_book_title".localized
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // register keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // remove keyboard notification
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - Functions

    /**
     Configuration and implementation search controller
     */
    private func prepareSearchController() {
        
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        // cancel button change color
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white] , for: .normal)
        
        //sets searchBar backgroundColor
        if let field = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            
            // text Color
            field.textColor = .white
            field.backgroundColor = .appBackgroundLight
            
            // placeholder text
            field.attributedPlaceholder = NSAttributedString(string: "search_placeholder".localized, attributes: [NSAttributedString.Key.foregroundColor: UIColor.appTextColor!])
            
            // change icon color
            if let iconView = field.leftView as? UIImageView {
                iconView.tintColor = .appTextColor
            }
        }
    }
    
    
    //MARK: - Keyboard
    
    @objc func keyBoardWillShow(_ notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            // move info view on top
            infoSearchVerticalConstraint.constant = -(keyboardFrame.cgRectValue.height / 3)
            // animation view
            UIView.animate(withDuration: notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        // set default value
        infoSearchVerticalConstraint.constant = 0
        // animation for center view
        UIView.animate(withDuration: notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    //MARK: - Load books
    
    /**
     Cancel request and set default visual
     */
    private func cancelBookLoadRequest() {
        // default visual
        activityIndicator.isHidden = true
        infoSearchView.isHidden = false
        
        // cancel last request and reset timer
        request?.cancel()
        request = nil
        requestTimer?.invalidate()
        requestTimer = nil
        
        // clear tableView and dataSource
        ManagerBookDataSource.shared().items.removeAll()
        tableView.reloadData()
        
        // default info text
        infoLabel.text = "search_book_info_label".localized
    }
    
    /**
     Load book of list
     
     - parameter searchText:          String
     */
    private func loadBookList(by searchText: String) {
        // show indicator
        activityIndicator.isHidden = false
        // hide info view
        infoSearchView.isHidden = true
        // set timer - delay 0.5 seconds
        requestTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { _ in
            self.request = ManagerBookDataSource.shared().loadBooks(by: searchText, resetDataSource: true) { success in
                if success {
                    // hide indicator
                    self.activityIndicator.isHidden = true
                    // refresh tableView
                    self.tableView.reloadData()
                    // nill request
                    self.request = nil
                    // empty result
                    if ManagerBookDataSource.shared().items.isEmpty {
                        self.infoSearchView.isHidden = false
                        self.infoLabel.text = "search_book_info_label_no_results".localized
                    }
                }
            }
        })
    }
}


//MARK: - DescriptionUISearchBarDelegate

extension SearchBookViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        cancelBookLoadRequest()
        
        if !searchText.isEmpty {
            loadBookList(by: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        cancelBookLoadRequest()
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource

extension SearchBookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManagerBookDataSource.shared().items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchBookTableViewCell", for: indexPath) as! SearchBookTableViewCell
        cell.prepareItem(ManagerBookDataSource.shared().items[indexPath.row].data)
        
        // "paging"
        if indexPath.row == ManagerBookDataSource.shared().items.count - 20, let searchText = searchController.searchBar.text {
            request = ManagerBookDataSource.shared().loadBooks(by: searchText) { success in
                if success {
                    // refresh tableView
                    tableView.reloadData()
                    self.request = nil
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // dismiss keyboard
        searchController.searchBar.resignFirstResponder()
    
        if let controller = DetailBookViewController.getController(indexPath.row, searchText: searchController.searchBar.text, callback: { addedNewItems, scrolledIndex in
            
            if addedNewItems {
                tableView.reloadData()
            }
            
            // scroll on item 
            tableView.scrollToRow(at: IndexPath(row: scrolledIndex, section: 0), at: .middle, animated: false)
        }) {
            // show book detail
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
