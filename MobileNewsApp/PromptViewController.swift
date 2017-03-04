//
//  PromptViewController.swift
//  MobileNewsApp
//
//  Created by Eitan Yarmush on 2/19/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import Parse


class PromptViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    

    var timeLimit: Double = 5.0
    var maxWords: Int = 100
    var participants: Int =  5
    var selecedPrompt: String = ""
    let genres : [String] = ["Horror", "Comedy", "Fiction", "Non-Fiction"]
    let genrePicker = UIPickerView()
    
    var story:Story?
    
    
    let whiteBorder : CALayer? = nil
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var genreField: UITextField!
    @IBOutlet weak var storyField: UITextView!
    @IBOutlet weak var timeLimitSlider: UISlider!
    @IBOutlet weak var timeLimitSliderValue: UILabel!
    @IBOutlet weak var wordCountSlider: UISlider!
    @IBOutlet weak var wordCountSliderValue: UILabel!
    @IBOutlet weak var participantSlider: UISlider!
    @IBOutlet weak var participantSliderLabel: UILabel!
    @IBOutlet weak var totalTurnsSlider: UISlider!
    @IBOutlet weak var totalTurnsSliderLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.delegate = self
        genreField.delegate = self

        setUpPicker()
        setupSliders()
        

        addUnderlines(textField: self.titleField)
        addUnderlines(textField: self.genreField)



        createWhiteUnderline()
        
        // Do any additional setup after loading the view.
    
    }
    
    //Function to set up genrePicker
    func setUpPicker() {
        genrePicker.delegate = self
        genrePicker.dataSource = self
        genrePicker.showsSelectionIndicator = true
        genreField.inputView = genrePicker
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PromptViewController.donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PromptViewController.donePicker))
        
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        genreField.inputAccessoryView = toolBar

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = UIColor(hex: Int("444444", radix: 16)!).cgColor
        color.toValue = UIColor(hex: Int("FFFFFF", radix: 16)!).cgColor
        color.duration = 0.5
        textField.layer.sublayers?[0].borderColor = UIColor(hex: Int("FFFFFF", radix: 16)!).cgColor
        textField.layer.add(color, forKey: "color and width")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let color = CABasicAnimation(keyPath: "borderColor")
        color.fromValue = UIColor(hex: Int("FFFFFF", radix: 16)!).cgColor
        color.toValue = UIColor(hex: Int("444444", radix: 16)!).cgColor
        color.duration = 0.5
        textField.layer.sublayers?[0].borderColor = UIColor(hex: Int("444444", radix: 16)!).cgColor
        textField.layer.add(color, forKey: "color and width")
    }
    
    
    
    //Function to add underlines under textFields
    func addUnderlines(textField: UITextField) {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor(hex: Int("444444", radix: 16)!).cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        
        
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
        
    }
    
    func createWhiteUnderline() {
        let width = CGFloat(1.0)
        self.whiteBorder?.borderColor = UIColor.white.cgColor
        self.whiteBorder?.borderWidth = width
        self.whiteBorder?.frame = CGRect(x: 0, y: self.titleField.frame.size.height - width, width:  self.titleField.frame.size.width, height: self.titleField.frame.size.height)
    }
    

    
    
    //Function to create function in DB
    func createStory() {
        
        
        //hey current user
        let user: PFUser = PFUser.current()!
        
        //
        let currentStory = Story(creator: user.objectId! as String, title: titleField.text!, genre: genreField.text!, prompt: self.selecedPrompt, wordCount: 100, timeLimit: self.timeLimit, participants: 10, totalTurns: 100)
        self.story = currentStory
        
        self.performSegue(withIdentifier: "beginStorySegue", sender: self)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createStoryButton(_ sender: Any) {
        //Check here that all of the fields are filled out
        var error = false
        if Util.checkEmpty(textField: titleField) {
            print("Title Field is empty")
            error = true
        }
        if Util.checkEmpty(textField: genreField) {
            print("genre field is empty")
            error = true
        }
//        if checkEmptyView(textField: storyField) {
//            print("text View is empty")
//            error = true
//        }
        if error { return }
        
        //
        createStory()
        
        //Segue to next screen, probably
        
    }
    
    
    //Function to update the values in the sliders
    @IBAction func timeLimitUpdate(_ sender: Any) {
        let slider = sender as! UISlider
        var currentVal: Int = 0
        if slider == timeLimitSlider {
            //Logic for Time Limit
            var roundedValue : Float = slider.value.rounded(.toNearestOrAwayFromZero)
            var resultString:String = ""
            let resultInt = Int(roundedValue)
            if  slider.value - roundedValue >= 0.25  {
                resultString = "\(resultInt):30"
                self.timeLimit = Double(resultInt*60+30)
                roundedValue += 0.5
            } else if roundedValue - slider.value >= 0.25 {
                resultString = "\(resultInt-1):30"
                self.timeLimit = Double((resultInt-1)*60+30)
                roundedValue -= 0.5
            } else {
                resultString = "\(resultInt):00"
                self.timeLimit = Double(resultInt*60)
            }
            timeLimitSliderValue.text = String(resultString)
        } else if slider == wordCountSlider {
            //Logic for wordCount
            currentVal = Int(slider.value)
            currentVal = (currentVal / 10)*10
            wordCountSliderValue.text = String(currentVal)
        } else if slider == participantSlider {
            //Logic for # of participants
            currentVal = Int(slider.value)
            participantSliderLabel.text = String(currentVal)
        } else if slider == totalTurnsSlider {
            //Logic for total # of turns
            currentVal = Int(slider.value)
            currentVal = (currentVal / 5)*5
            totalTurnsSliderLabel.text = String(currentVal)
        } else {
            return
        }
    }
    
    
    //Function to make sliders look right and create appropaiate values
    func setupSliders() {
        timeLimitSlider.minimumValue = 0.49
        timeLimitSlider.maximumValue = 10.0
        timeLimitSlider.value = 5.0
        timeLimitSliderValue.text = "5:00"
        
        wordCountSlider.minimumValue = 100
        wordCountSlider.maximumValue = 200
        wordCountSlider.value = 150
        
        participantSlider.minimumValue = 5
        participantSlider.maximumValue = 20
        participantSlider.value = 10
        
        totalTurnsSlider.minimumValue = 25
        totalTurnsSlider.maximumValue = 200
        totalTurnsSlider.value = 50
        
    }
    
    //Code to set up Genre Picker
    func donePicker() {
        
        genreField.resignFirstResponder()
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.genres.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.genres[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.genreField.text = genres[row]
    }

    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "beginStorySegue" {
            let storyViewController = segue.destination as! FirstEntryViewController
            storyViewController.story = self.story
        }
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
 
    
}
