//
//  StateDetailTableViewController.swift
//  Representative
//
//  Created by Madison Kaori Shino on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateDetailTableViewController: UITableViewController {
    
    //PROPERTIES
    var state: String?

    var representatives: [Representative] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedState = state {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            title = unwrappedState
            RepresentativeController.fetchReps(forState: unwrappedState) { (reps) in
                guard let repArray = reps else { return }
                self.representatives = repArray
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }
        }
    }
    
    //TABLEVIEWS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return representatives.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       guard let cell = tableView.dequeueReusableCell(withIdentifier: "repCell", for: indexPath) as? RepTableViewCell else { return UITableViewCell() }

       cell.representatives = representatives[indexPath.row]
        
        return cell
    }
}
