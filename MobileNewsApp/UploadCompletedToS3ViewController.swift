//
//  UploadCompletedToS3ViewController.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 3/25/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3

class UploadCompletedToS3ViewController: UIViewController, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //credentials
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2,
                                                                identityPoolId:"us-west-2:bb5dab7f-bb7e-405b-8498-6a5fb644f4aa")
        
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        //file information
        let S3BucketName = "mobile-news-app"
        
        //let remoteName = ""
        
        
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.bucket = S3BucketName
        uploadRequest?.key = "test"
        uploadRequest?.body = URL(fileURLWithPath: "/Users/neliaperez/Desktop/1.pdf")
        
        let transferManager = AWSS3TransferManager.default()
        //let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        transferManager.upload(uploadRequest!).continueWith(executor: AWSExecutor.mainThread(), block: { (task:AWSTask<AnyObject>) -> Any? in
            
            if let error = task.error as? NSError {
                if error.domain == AWSS3TransferManagerErrorDomain, let code = AWSS3TransferManagerErrorType(rawValue: error.code) {
                    switch code {
                    case .cancelled, .paused:
                        break
                    default:
                        print("Error uploading: \(uploadRequest?.key) Error: \(error)")
                    }
                } else {
                    print("Error uploading: \(uploadRequest?.key) Error: \(error)")
                }
                return nil
            }
            
            let uploadOutput = task.result
            print("Upload complete for: \(uploadRequest?.key)")
            return nil
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
   }
