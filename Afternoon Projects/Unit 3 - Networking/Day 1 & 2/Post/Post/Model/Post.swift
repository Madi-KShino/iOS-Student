//
//  Post.swift
//  Post
//
//  Created by Madison Kaori Shino on 6/24/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

struct Post: Codable {
    
    let userName: String
    let text: String
    let timeStamp: TimeInterval
    
    init(userName: String, text: String, timeStamp: TimeInterval = Date().timeIntervalSince1970) {
        self.userName = userName
        self.text = text
        self.timeStamp = timeStamp
    }
}
