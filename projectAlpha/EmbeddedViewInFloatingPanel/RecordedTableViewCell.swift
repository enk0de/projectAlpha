//
//  TableViewCell.swift
//  projectAlpha
//
//  Created by Mac on 28/07/2019.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit

class RecordedTableViewCell: UITableViewCell {

    @IBOutlet weak var fileName: UILabel!
    @IBOutlet weak var fileDate: UILabel!
    @IBOutlet weak var fileAudioLength: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
