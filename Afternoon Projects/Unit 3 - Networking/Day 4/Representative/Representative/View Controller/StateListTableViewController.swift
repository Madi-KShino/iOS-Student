//
//  StateListTableViewController.swift
//  Representative
//
//  Created by Madison Kaori Shino on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class StateListTableViewController: UITableViewController {

    //LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //TABLE VIEWA
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return States.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)

        let state = States.all[indexPath.row]
        cell.textLabel?.text = state

        return cell
    }

    // NAVIGATION
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStateDetail" {
            guard let index = tableView.indexPathForSelectedRow,
            let destination = segue.destination as? StateDetailTableViewController
            else { return }
            destination.state = States.all[index.row]
        }
    }
}
