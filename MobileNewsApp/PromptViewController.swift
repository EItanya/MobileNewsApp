//
//  PromptViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 2/19/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse

class PromptViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    var selecedPrompt: String = ""
    var prompts: [String] = []
    private var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup Table View
        tableView = UITableView(frame: CGRect(x: 10, y: 50, width: self.view.frame.width, height:500), style: UITableViewStyle.plain)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView?.rowHeight = UITableViewAutomaticDimension
        tableView?.estimatedRowHeight = 200
        super.view.addSubview(tableView!)
        
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
                            let promptObj =  value as! [String: Any]
                            let promptData = promptObj["data"] as! [String: Any]
                            let promptTemp = promptData["title"] as! String
                            let promptString = promptTemp.substring(from: promptTemp.index(promptTemp.startIndex, offsetBy: 4))
                            self.prompts.append(promptString)
                            DispatchQueue.main.async {
                                self.tableView?.reloadData()
                            }
                        }
                        
                    }
                } catch {
                    print("error in JSONSerialization")
                    
                }
            }
        })
        task.resume()
    }
    
    //Function to deal with create story
    @IBAction func createStory(_ sender: Any) {
        
    }
    
    //Function to create story in DB
    func createStory() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.prompts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
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
