//
//  CreateViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 2/18/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    var selecedPrompt: String = ""
    var prompts: [String] = []
    
    var viewHasLoaded:Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set height of table view cells
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 200
        tableView?.backgroundColor = UIColor.clear
        
        
        //Fetch Prompt Data from Reddit
        fetchData()
        
        // Do any additional setup after loading the view.
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        animateTable()
//    }
    
    func fetchData() {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://www.reddit.com/r/writingprompts/top.json?limit=8")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print("Error getting reddit data:", error ?? "")
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        //Implement your logic
                        //print(json)
                        let x = json["data"] as! [String: Any]
                        let subresults = x["children"] as! [Any]
                        for (value) in subresults {
                            //Nested JSON sucks
                            let promptObj =  value as! [String: Any]
                            let promptData = promptObj["data"] as! [String: Any]
                            let promptTemp = promptData["title"] as! String
                            let promptString = self.cleanString(prompt: promptTemp)
                            
                            self.prompts.append(promptString)
                        }
                        self.prompts.append("Create Your Own Story...")
                        DispatchQueue.main.async {
                            if !self.viewHasLoaded {
                                self.animateTable()
                                self.viewHasLoaded = true
                            }
                            //self.tableView?.reloadData()
                            
                        }
                        
                    }
                } catch {
                    print("error in JSONSerialization")
                    
                }
            }
        })
        task.resume()
    }

    
    func animateTable () {
        tableView.reloadData()
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.bounds.size.height
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
        }
        
        var delayCounter = 0
        for cell in cells {
            UIView.animate(withDuration: 1.75, delay: Double(delayCounter) * 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                cell.transform = CGAffineTransform.identity
            }, completion: nil)
            delayCounter += 1
        }
        
    }
    
    
    func cleanString(prompt: String) -> String {
        //Remove [WP] from strings
        var promptString = prompt.substring(from: prompt.index(prompt.startIndex, offsetBy: 4))
        //Check for initial space and remove it
        if promptString[promptString.startIndex] == " " { promptString.remove(at: promptString.startIndex) }
        return promptString
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prompts.count
    }
    
    //Function to return cells at IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "promptCell", for: indexPath)
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = self.prompts[indexPath.row]
        cell.textLabel?.font = UIFont(name: "DIN", size: 17.0)
        return cell
    }
    
    //Code that is executed when a table cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selecedPrompt = self.prompts[indexPath.row]
        
        let cells = tableView.visibleCells
        for cell in cells {
            cell.textLabel?.numberOfLines = 2
        }
        let cell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        cell.textLabel?.numberOfLines = 0
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row % 2 == 0)
        {
            cell.backgroundColor = UIColor(colorLiteralRed: 247/255, green: 243/255, blue: 242/255, alpha: 1)
        } else {
            cell.backgroundColor = UIColor.white
        }
    }
    

        
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 80.0
//    }
    
    //Function to segue into creation screen
    @IBAction func createStory(_ sender: Any) {
        self.performSegue(withIdentifier: "createStorySegue", sender: self)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "createStorySegue" {
            let promptController = segue.destination as! PromptViewController
            promptController.selecedPrompt = self.selecedPrompt
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
    
}

