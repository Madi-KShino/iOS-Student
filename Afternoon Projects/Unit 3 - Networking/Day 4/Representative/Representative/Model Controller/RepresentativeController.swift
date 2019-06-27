//
//  RepresentativeController.swift
//  Representative
//
//  Created by Madison Kaori Shino on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class RepresentativeController {
    
    static let baseURL = URL(string: "https://whoismyrepresentative.com/getall_reps_bystate.php")
    
    static func fetchReps(forState state: String, completion: @escaping (([Representative]?) -> Void )) {
        
        guard let unwrappedUrl = baseURL else { completion([]); return }
        var components = URLComponents(url: unwrappedUrl, resolvingAgainstBaseURL: true)
        let searchQuery = URLQueryItem(name: "state", value: state.lowercased())
        let jsonQuery = URLQueryItem(name: "output", value: "json")
        components?.queryItems = [searchQuery, jsonQuery]
        guard let finalURL = components?.url else { completion([]); return }
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Oh no! Search error: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data,
            let responseDataString = String(data: data, encoding: .ascii),
            let fixedData = responseDataString.data(using: .utf8)
                else { completion([]); return }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([String: [Representative]].self, from: fixedData)
                let representatives = decodedData["results"]
                completion(representatives)
            } catch {
                print("Uh no! Decoding error: \(error.localizedDescription)")
            }
        }.resume()
    }
}
