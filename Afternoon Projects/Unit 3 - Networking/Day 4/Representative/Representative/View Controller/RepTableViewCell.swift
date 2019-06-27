//
//  RepTableViewCell.swift
//  Representative
//
//  Created by Madison Kaori Shino on 6/27/19.
//  Copyright © 2019 DevMtnStudent. All rights reserved.
//

import UIKit

class RepTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    var representatives: Representative? {
        didSet {
            updateViews()
        }
    }

    func updateViews() {
        
        guard let reps = representatives else { return }
        nameLabel.text = reps.name
        partyLabel.text = reps.party
        districtLabel.text = "District: \(reps.district)"
        phoneLabel.text = reps.phone
        websiteLabel.text = reps.link
    }
}
