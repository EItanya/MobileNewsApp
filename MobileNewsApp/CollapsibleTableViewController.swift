//
//  CollapsibleTableViewController.swift
//  ios-swift-collapsible-table-section
//
//  Created by Yong Su on 5/30/16.
//  Copyright © 2016 Yong Su. All rights reserved.
//

import UIKit
import M13Checkbox

//
// MARK: - Section Data Structure
//
struct Section {
    var name: String!
    var items: [String]!
    var collapsed: Bool!
    
    init(name: String, items: [String], collapsed: Bool = false) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
    }
}

//
// MARK: - View Controller
//

protocol FilterTableViewDelegate {
    func checkboxValueChanged2(value: Int, section: Int, row: Int)
}

class CollapsibleTableViewController: UITableViewController {
    
    var sections = [Section]()
    var delegate: HomeViewController?
    
    var genreValues: [Bool]?
    var wordCountValues: [Bool]?
    var numContValues: [Bool]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Apple Products"
        
        // Initialize the sections array
        // Here we have three sections: Mac, iPad, iPhone
        sections = [
            Section(name: "Genre", items: ["Horror", "Comedy", "Fiction", "Non-Fiction"]),
            Section(name: "Word Count", items: ["Short", "Medium", "Long"]),
            Section(name: "Number of Contributors", items: ["Couple", "Some", "Many"])
        ]
    }
    
}

//
// MARK: - View Controller DataSource and Delegate
//
extension CollapsibleTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    // Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> GenreTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell") as! GenreTableViewCell
        
        cell.itemLabel?.text = sections[indexPath.section].items[indexPath.row]
        cell.delegate = self
        cell.section = indexPath.section
        cell.row = indexPath.row
        var checkedState = M13Checkbox.CheckState.unchecked
        
        if indexPath.section == 0 && genreValues?[indexPath.row] == true {
            checkedState = M13Checkbox.CheckState.checked
        }
        else if indexPath.section == 1 && wordCountValues?[indexPath.row] == true {
            checkedState = M13Checkbox.CheckState.checked
        }
        else if indexPath.section == 2 && numContValues?[indexPath.row] == true {
            checkedState = M13Checkbox.CheckState.checked
        }
        cell.checkboxOutlet.setCheckState(checkedState, animated: true)

        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(sections[indexPath.section])
        print(sections[indexPath.section].items[indexPath.row])
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[indexPath.section].collapsed! ? 0 : 44.0
    }
    
    // Header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

}

//
// MARK: - Section Header Delegate
//
extension CollapsibleTableViewController: CollapsibleTableViewHeaderDelegate {
    
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        // Adjust the height of the rows inside the section
        tableView.beginUpdates()
        for i in 0 ..< sections[section].items.count {
            tableView.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableView.endUpdates()
    }
    
}

//
// MARK: - Filter Cell Delegate
//
extension CollapsibleTableViewController: FilterTableViewCellDelegate {
    func checkboxValueChanged(value: Int, section: Int, row: Int) {
        print("Detected inside Filter table")
        self.delegate?.checkboxValueChanged2(value: value, section: section, row: row)
    }
}
