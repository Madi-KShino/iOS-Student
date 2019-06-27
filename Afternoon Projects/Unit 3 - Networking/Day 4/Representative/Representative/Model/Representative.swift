//
//  Representative.swift
//  Representative
//
//  Created by Madison Kaori Shino on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import Foundation

//struct TopLevelJson

struct Representative: Decodable {
    
    let name: String
    let party: String
    let state: String
    let district: String
    let phone: String
    let office: String
    let link: String
    
}

