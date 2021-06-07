//
//  HomeTableViewController.swift
//  TODO
//
//  Created by DonorRaja on 7/06/21.
//

import UIKit
import Alamofire
import SwiftyJSON
import iProgressHUD

class HomeTableViewController: UITableViewController {

    //MARK: - Outlets
    
    
    //MARK: - Variables
    var lists = [ListModel]()

    let searchController = UISearchController(searchResultsController: nil)
    var filterSearch:[ListModel] = []
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadList()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = TODO.Search.searchHere
        navigationItem.searchController = searchController
        definesPresentationContext = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
            return filterSearch.count
        }
        return self.lists.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: TODO.Cell.listCell) as! ListTableViewCell
        let list: ListModel
        if isFiltering {
            list = filterSearch[indexPath.row]
        }else {
            list = lists[indexPath.row]
        }
        cell.idLabel.text = "ID : \(String(describing: list.id!))"
        cell.completionLabel.text = "completion : \(String(describing: list.completed!))"
        cell.titleLabel.text = "Title : \(String(describing: list.title!))"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: TODO.Segue.detailsView, sender: indexPath)
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TODO.Segue.detailsView {
            let indexPath = sender as! IndexPath
            let vc = segue.destination as! DetailsViewController
            let listDetail = self.lists[indexPath.row]
            vc.userID = listDetail.id
            vc.detailText = listDetail.title
            vc.completedText = listDetail.completed
        }
    }
    
   //MARK: - Functions
    func loadList(){
        iProgressHUD.sharedInstance().attachProgress(toView: self.view)
        self.view.showProgress()
        if NetworkState.isConnected() {
            let url = TODO.API.apiURL + TODO.API.todos
                AF.request(url).responseJSON { (response) in
                    switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        print(json)

                        for value in json.arrayValue {
                            let completed = value.dictionaryValue[TODO.Model.completed]!.stringValue
                            let userId = value.dictionaryValue[TODO.Model.userId]!.stringValue
                            let id = value.dictionaryValue[TODO.Model.id]!.stringValue
                            let title = value.dictionaryValue[TODO.Model.title]!.stringValue

                            // Add this list to array.
                            let list = ListModel(id: id, userId: userId, title: title, completed: completed)
                            self.lists.append(list)
                            self.view.dismissProgress()
                        }
                        self.tableView.reloadData()
                    case .failure(let error):
                        print(error)
                        self.view.dismissProgress()
                    }

                }
        }else{
            self.view.dismissProgress()
            self.showAlert(withTitle: TODO.Alert.alert, withMessage: TODO.Alert.networkError)
        }
        
    }

   
}

extension HomeTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
      filterSearch = lists.filter { (list: ListModel) -> Bool in
        return list.title!.lowercased().contains(searchText.lowercased())
      }
      
      tableView.reloadData()
    }
}

extension HomeTableViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
      selectedScopeButtonIndexDidChange selectedScope: Int) {
      filterContentForSearchText(searchBar.text!)
  }
}
