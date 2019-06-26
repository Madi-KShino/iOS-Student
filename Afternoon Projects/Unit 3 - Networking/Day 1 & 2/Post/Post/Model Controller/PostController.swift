//
//  PostController.swift
//  Post
//
//  Created by Madison Kaori Shino on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

class PostController {
    
    //URL
    let baseURL = URL(string: "http://devmtn-posts.firebaseio.com/posts")
    
    //PROPERTIES
    var posts: [Post] = []
    
    //RETRIEVE DATA
    func fetchPosts(reset: Bool = true, completion: @escaping() -> Void) {
        
        let queryEndInterval = reset ? Date().timeIntervalSince1970: posts.last?.timestamp ?? Date().timeIntervalSince1970
        
        guard let unwrappedURL = baseURL else { completion(); return }
        
        let urlParameters = ["orderBy":"\"timestamp\"",
                             "endAt":"\(queryEndInterval)",
            "limitToLast":"15"]
        let queryItems = urlParameters.compactMap({ URLQueryItem(name: $0.key, value: $0.value)} )
        var urlComponents = URLComponents(url: unwrappedURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else { return }
        
        let getterEndpoint = url.appendingPathExtension("json")
        var request = URLRequest(url: getterEndpoint)
        request.httpBody = nil
        request.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
                completion()
                return
            }
            
            guard let data = data else { completion(); return}
            let decoder = JSONDecoder()
            do {
                let postsDictionary = try decoder.decode([String:Post].self, from: data)
                let posts: [Post] = postsDictionary.compactMap({ $0.value })
                let sortedPosts = posts.sorted(by: { $0.timestamp > $1.timestamp })
                if reset {
                    self.posts = sortedPosts
                } else {
                    self.posts.append(contentsOf: sortedPosts)
                }
                completion()
            } catch {
                print(error)
                completion()
                return
            }
        }
        dataTask.resume()
    }
    
    //NEW POSTS
    func addNewPostWith(username: String, text: String, completion: @escaping() -> Void) {
        let newPost = Post(username: username, text: text)
        var postData: Data
        do {
            let jsonEncoder = JSONEncoder()
            postData = try jsonEncoder.encode(newPost)
        } catch {
            print("Error encoding data \(error.localizedDescription)")
            completion()
            return
        }
        
        guard let baseUrl = baseURL else { completion(); return }
        let postEndpoint = baseUrl.appendingPathExtension("json")
        
        var request = URLRequest(url: postEndpoint)
        request.httpBody = postData
        request.httpMethod = "POST"
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion()
                NSLog(error.localizedDescription)
                return
            }
            
            guard let data = data,
                let responseDataString = String(data: data, encoding: .utf8) else {
                    completion()
                    NSLog("Data is nil")
                    return
            }
            
            NSLog(responseDataString)
            self.fetchPosts {
                completion()
            }
        }
        dataTask.resume()
    }
}
