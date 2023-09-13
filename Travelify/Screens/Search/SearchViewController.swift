//
//  SearchViewController.swift
//  Travelify
//
//  Created by Minh Tan Vu on 12/09/2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import Kingfisher

extension String {
    func removeDiacriticsAndConvertToLowercase() -> String {
        let folded = folding(options: .diacriticInsensitive, locale: .current)
        return folded.lowercased()
    }
}

class SearchViewController: UIViewController {

    @IBOutlet weak var searchImgView: UIImageView!
    @IBOutlet weak var clearSearchHistoryBtn: UIButton!
    @IBOutlet weak var searchBarTF: CustomSearchBarUITextField2!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var suggestionTableView: UITableView!
    @IBOutlet weak var historyTableViewHeight: NSLayoutConstraint!
    
    var isFromHome: Bool! = false
    var databaseRef = Database.database().reference()
    var storage = Storage.storage().reference()
    var currentUserID = Auth.auth().currentUser?.uid
    var searchHistory: [Place] = []
    var listPlaces: [Place] = []
    var results: [Place] = []
    
    var searchResultsTableView: UITableView!
    
    override func loadView() {
        super.loadView()
        
        self.listPlaces = (UIApplication.shared.delegate as? AppDelegate)!.listPlaces.shuffled()
        
        setupTableView()
        print(listPlaces)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBarTF.delegate = self
        setupTableView()
        
        setupResultTableView()
        
        self.searchHistory = loadSearchHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Tìm kiếm"
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.backItem?.backButtonTitle = ""
        
        historyTableView.reloadData()
        
        if isFromHome {
            searchBarTF.becomeFirstResponder()
        }
        
        if searchHistory.isEmpty {
            clearSearchHistoryBtn.isHidden = true
        } else {
            clearSearchHistoryBtn.isHidden = false
        }
        
    }
    
    //Config Observer Value for tableView to setup tableViewHeight
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? UITableView {
            if obj == self.historyTableView && keyPath == "contentSize" {
                if let newSize = change?[NSKeyValueChangeKey.newKey] as? CGSize {
//                    let height = newSize.height
//                    print(height)
                    self.historyTableViewHeight.constant = self.historyTableView.contentSize.height
                }
            }
        }
    }
    
    func setupTableView() {
        
        historyTableView.dataSource = self
        historyTableView.delegate = self
        historyTableView.register(UINib(nibName: "HistoryTableViewCell", bundle: nil), forCellReuseIdentifier: "HistoryTableViewCell")
        historyTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        historyTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0,width: historyTableView.frame.width, height: CGFloat.leastNormalMagnitude))
        historyTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: historyTableView.frame.width, height: CGFloat.leastNormalMagnitude))
        historyTableView.reloadData()
        
        suggestionTableView.dataSource = self
        suggestionTableView.delegate = self
        suggestionTableView.register(UINib(nibName: "HighRatingTableViewCell", bundle: nil), forCellReuseIdentifier: "HighRatingTableViewCell")
        suggestionTableView.reloadData()
    }
    
    func setupResultTableView() {
        
        searchResultsTableView = UITableView(frame: CGRect(x: 0, y: searchBarTF.frame.maxY + 8, width: self.view.frame.width, height: self.view.frame.height - (searchBarTF.frame.maxY + 8)), style: .grouped)
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.isHidden = true
        searchResultsTableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")
        searchResultsTableView.backgroundColor = .clear
        
        self.view.addSubview(searchResultsTableView)
        
    }
    
    @IBAction func searchBarOnChange(_ sender: CustomSearchBarUITextField2) {
    
    }
    
    @IBAction func clearSearchHistory(_ sender: UIButton) {
        self.searchHistory.removeAll()
        UserDefaults.standard.removeObject(forKey: "searchHistory")
        historyTableView.reloadData()
        clearSearchHistoryBtn.isHidden = true
    }
    
}

//MARK: - SearchBar TextField

extension SearchViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            results = searchPlaces(query: text)
            searchResultsTableView.reloadData()
            searchResultsTableView.isHidden = false
        }
        
        return true
    }
    
    func searchPlaces(query: String) -> [Place] {
        let queryNomalized = query.removeDiacriticsAndConvertToLowercase()
        
        let filteredPlaces = listPlaces.filter { place in
            if let name = place.name?.removeDiacriticsAndConvertToLowercase(), name.contains(queryNomalized) {
                return true
            }
            
            if let location = place.location?.removeDiacriticsAndConvertToLowercase(), location.contains(queryNomalized) {
                return true
            }
            
            return false
        }
        
        return filteredPlaces
    }
}


//MARK: - TableView Datasource Methods
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView {
            return searchHistory.count
        } else if tableView == suggestionTableView {
            return 5
        } else if tableView == searchResultsTableView {
            return results.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView {
            let historyCell = historyTableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
            
            let model = self.searchHistory[indexPath.row]
            historyCell.bindData(placeName: model.name!)
            return historyCell
        } else if tableView == suggestionTableView {
            
            if indexPath.row < listPlaces.count {
                let suggestionCell = suggestionTableView.dequeueReusableCell(withIdentifier: "HighRatingTableViewCell", for: indexPath) as! HighRatingTableViewCell
                
                let model = listPlaces[indexPath.row]
                suggestionCell.binData(image: model.avatar!, name: model.name!, location: model.location!, description: model.description!)
                return suggestionCell
            }
        } else if tableView == searchResultsTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath)
            let place = results[indexPath.row]
            
            // Hiển thị dữ liệu từ đối tượng Place lên cell
            var config = UIListContentConfiguration.cell()
            config.text = place.name
            config.secondaryText = place.location
            config.secondaryTextProperties.color = .lightGray
            
            cell.contentConfiguration = config
            return cell
        }
        return UITableViewCell()
    }
    
    
}
//MARK: - TableView Delegate methods
extension SearchViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == suggestionTableView {
            routeToDetail(dataSource: listPlaces, with: indexPath)
            suggestionTableView.deselectRow(at: indexPath, animated: true)
            
        } else if tableView == historyTableView {
            routeToDetail(dataSource: searchHistory, with: indexPath)
            historyTableView.deselectRow(at: indexPath, animated: true)
            historyTableView.reloadData()
            
        } else if tableView == searchResultsTableView {
            let selectedPlace = results[indexPath.row]
            saveSearchHistory(place: selectedPlace)
            self.searchHistory = loadSearchHistory()
            
            routeToDetail(dataSource: results, with: indexPath)
            searchBarTF.text = ""
            searchResultsTableView.isHidden = true
            searchResultsTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func routeToDetail(dataSource: [Place], with indexPath: IndexPath) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: nil)
        detailVC.place = dataSource[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func saveSearchHistory(place: Place) {
        var searchHistory = UserDefaults.standard.value(forKey: "searchHistory") as? [Data] ?? []

        if let encodedPlace = try? JSONEncoder().encode(place) {
            searchHistory.insert(encodedPlace, at: 0)
            
            if searchHistory.count > 5 {
                searchHistory.removeLast()
            }
            
            UserDefaults.standard.set(searchHistory, forKey: "searchHistory")
        }
    }
    
    func loadSearchHistory() -> [Place] {
        let searchHistoryData = UserDefaults.standard.array(forKey: "searchHistory") as? [Data] ?? []
        let decoder = JSONDecoder()
        var searchHistory: [Place] = []

        for data in searchHistoryData {
            if let place = try? decoder.decode(Place.self, from: data) {
                searchHistory.append(place)
            }
        }

        return searchHistory
    }
}
