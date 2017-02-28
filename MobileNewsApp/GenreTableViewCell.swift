//
//  GenreTableViewCell.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 2/27/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import M13Checkbox

protocol FilterTableViewCellDelegate {
    func checkboxValueChanged(value: Int, section: Int, row: Int)
}

class GenreTableViewCell: UITableViewCell {
    
    
    var delegate: CollapsibleTableViewController?
    
    var section: Int?
    var row: Int?
    
    @IBOutlet var itemLabel: UILabel!
    @IBOutlet var checkboxOutlet: M13Checkbox!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func checkboxClk1(_ sender: Any) {
        print("detected")
        self.delegate?.checkboxValueChanged(value: checkboxOutlet.checkState.hashValue, section: self.section!, row: self.row!)
    }
}
