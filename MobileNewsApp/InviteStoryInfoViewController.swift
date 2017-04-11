//
//  InviteStoryInfoViewController.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 4/10/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit

protocol InviteStoryInfoDelegate {
    
    func acceptInvite()
    
    func declineInvite()
}

class InviteStoryInfoViewController: UIViewController {

    var delegate: ManageInviteTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func acceptBtnClk(_ sender: UIButton) {
        delegate?.acceptInvite()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func declineBtnClk(_ sender: UIButton) {
        delegate?.declineInvite()
        self.dismiss(animated: true, completion: nil)
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
