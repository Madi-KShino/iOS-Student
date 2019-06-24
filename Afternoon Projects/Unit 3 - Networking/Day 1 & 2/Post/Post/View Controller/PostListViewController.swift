//
//  PostListViewController.swift
//  Post
//
//  Created by Madison Kaori Shino on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //PROPERTIES
    let postController = PostController()
    
    var refreshControl = UIRefreshControl()
    
    //OUTLETS
    @IBOutlet weak var tableView: UITableView!
    
    
    //LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //DATASOURCE & DELEGATE
        tableView.delegate = self
        tableView.dataSource = self
        
        //ROW DIMENSIONS
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        //REFRESH
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        postController.fetchPosts {
            self.reloadTableView()
        }
    }
    
    //FUNCTIONS
    @objc func refreshControlPulled() {
        postController.fetchPosts {
            self.reloadTableView()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
    
    //TABLE VIEW
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username) - \(post.timestamp)"
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
