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
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set height of table view cells
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 200
        
        //Fetch Prompt Data from Reddit
        fetchData()
        
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let url = URL(string: "https://www.reddit.com/r/writingprompts/top.json?limit=5")!
        
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
                            self.tableView?.reloadData()
                        }
                        
                    }
                } catch {
                    print("error in JSONSerialization")
                    
                }
            }
        })
        task.resume()
    }

    
    
    func cleanString(prompt: String) -> String {
        //Remove [WP] from strings
        var promptString = prompt.substring(from: prompt.index(prompt.startIndex, offsetBy: 4))
        //Check for initial space and remove it
        if promptString[promptString.startIndex] == " " { promptString.remove(at: promptString.startIndex) }
        return promptString
    }
    
    //Function to create story in DB
    func createStory() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prompts.count
    }
    
    //Function to return cells at IndexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "promptCell", for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = self.prompts[indexPath.row]
        return cell
    }
    
    //Code that is executed when a table cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selecedPrompt = self.prompts[indexPath.row]
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

