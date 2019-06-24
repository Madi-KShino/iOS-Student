//
//  PostController.swift
//  Post
//
//  Created by Madison Kaori Shino on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController {
    
    let baseURL = URL(string: "https://devmtn-posts.firebaseio.com/posts")
    
    var posts = [Post]()
    
    func fetchPosts(completion: @escaping() -> Void) {
        guard let baseURL = baseURL else { completion(); return }
        let getterEndpoint = baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion()
                return
            }
            
            guard let data = data else { completion(); return }
            
            let decoder = JSONDecoder()
            
            do {
                let postsDictionary = try decoder.decode([String:Post].self, from: data)
                var posts = postsDictionary.compactMap({ ($0.value) })
                posts.sort(by: { $0.timestamp > $1.timestamp } )
                self.posts = posts
                completion()
            } catch {
                print("error \(error.localizedDescription)")
                completion()
                return
            }
        }
        dataTask.resume()
    }
}
