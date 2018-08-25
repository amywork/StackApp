//
//  ExploreViewController.swift
//  1018_Fanxy
//
//  Created by 김기윤 on 20/10/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit

class ExploreController: UIViewController, RouterProtocol {
    static var storyboardName: String = "Main"
    

    struct TableViewConstants {
        static let tableViewCellIdentifier = "SearchResultsCell"
    }
    
    @IBOutlet weak var tableView: UITableView!
    var searchController: UISearchController!
    var allResults: [Explore] = GlobalState.shared.explores
    var visibleResults: [Explore] = []
    
    var refreshControl: UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
        // Create the search results view controller and use it for the `UISearchController`.
        let searchResultsController = storyboard!.instantiateViewController(withIdentifier: SearchResultsController.StoryboardConstants.identifier) as! SearchResultsController
        // Create the search controller and make it perform the results updating.
        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.placeholder = NSLocalizedString("Search", comment: "services")
        // Include the search bar within the navigation bar.
        navigationItem.titleView = searchController.searchBar
        definesPresentationContext = true
        
        
        App.api.fetchExplores { (isSuccess) in
            if isSuccess {
                self.allResults = GlobalState.shared.explores
                DispatchQueue.main.async {
                    self.filterString = nil
                }
            }
        }
        
    }
    
    @objc func refresh() {
        App.api.fetchExplores { (isSuccess) in
            if isSuccess {
                self.allResults = GlobalState.shared.explores
                DispatchQueue.main.async {
                    self.filterString = nil
                    self.refreshControl?.endRefreshing()
                }
            }
        }
    }
    
    
    /// A `nil` / empty filter string means show all results. Otherwise, show only results containing the filter.
    var filterString: String? = nil {
        didSet {
            if filterString == nil || filterString!.isEmpty {
                visibleResults = allResults
            }
                
            else {
                // Filter the results using a predicate based on the filter string.
                let filterPredicate = NSPredicate(format: "self contains[c] %@", argumentArray: [filterString!])
                var list:[String] = []
                print(allResults)
                for result in allResults {
                    let title = result.title
                    list.append(title)
                }
                list = list.filter { filterPredicate.evaluate(with: $0) }
                var lastArr: [Explore] = []
                for title in list {
                    for data in visibleResults {
                        if data.title == title {
                            lastArr.append(data)
                        }
                    }
                }
                visibleResults = lastArr
                //print(visibleResults)
            }
            tableView.reloadData()
        }
    }

    @IBAction func unwindToExploreController(segue: UIStoryboardSegue) {
    
    }
}

/*UITableViewDataSource*/
extension ExploreController: UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "✔︎ For Tech Savvys"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewConstants.tableViewCellIdentifier, for: indexPath) as! SearchResultsCell
        cell.data = visibleResults[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        let sb = UIStoryboard.main()
        let destination = sb.instantiateViewController(withIdentifier: "AddNewController") as! AddNewController
        destination.name = visibleResults[indexPath.row].title
        destination.descriptions = visibleResults[indexPath.row].description
        let navi = UINavigationController(rootViewController: destination)
        self.present(navi, animated: true, completion: nil)
        //self.navigationController?.pushViewController(destination, animated: true)
    }

}

