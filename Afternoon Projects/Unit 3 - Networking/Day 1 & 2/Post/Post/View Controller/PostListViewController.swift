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
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        postController.fetchPosts {
            self.reloadTableView()
        }
    }
    
    //ACTIONS
    @IBAction func addButtonTapped(_ sender: Any) {
        addPostAlert()
    }
    
    //FUNCTIONS - REFRESH
    @objc func refreshControlPulled() {
        postController.fetchPosts {
            self.reloadTableView()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    //FUNCTIONS - ADD ALERT
    func addPostAlert() {
        let alertController = UIAlertController(title: "New Post", message: "Add a new message to the board.", preferredStyle: .alert)
        
        var messageTextField = UITextField()
        alertController.addTextField { (textField) in
            textField.placeholder = "What do you want to say?"
            messageTextField = textField
        }
        
        var usernameTextField = UITextField()
        alertController.addTextField { (usernameField) in
            usernameField.placeholder = "Add your name..."
            usernameTextField = usernameField
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (addAction) in
            guard let username = usernameTextField.text, !username.isEmpty,
                let message = messageTextField.text, !message.isEmpty
                else { self.presentErrorAlert(); return }
            self.postController.addNewPostWith(username: username, text: message, completion: {
                self.reloadTableView()
            })
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //FUNCTIONS - ERROR ALERT
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Incomplete Form", message: "Make sure to add a username and a message", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Got it", style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //FUNCTIONS - RELOAD
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
}

//PROTOCOL CONFORMANCE
extension PostListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= postController.posts.count - 1 {
            postController.fetchPosts(reset: false) {
                self.reloadTableView()
            }
        }
    }
}
