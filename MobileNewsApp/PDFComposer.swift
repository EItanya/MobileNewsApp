//
//  PDFComposer.swift
//  MobileNewsApp
//
//  Created by Nelia Perez on 3/25/17.
//  Copyright © 2017 cs378. All rights reserved.
//

import UIKit
import AWSCore
import AWSS3

class PDFComposer: NSObject {

    let pathToInvoiceHTMLTemplate = Bundle.main.path(forResource: "complete_story", ofType: "html")
    
    var story: Story?
    
    var pdfFilename: String!
    
    //let pathToSingleItemHTMLTemplate = Bundle.main.path(forResource: "single_item", ofType: "html")
    
    init(story: Story) {
        self.story = story
    }
    
    func renderHTML() -> String! {
        do {
            var HTMLContent = try String(contentsOfFile: pathToInvoiceHTMLTemplate!)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TITLE#", with: story!.title!)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#AUTHOR#", with: story!.author!)
                        HTMLContent = HTMLContent.replacingOccurrences(of: "#GENRE#", with: story!.author!)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TIME#", with: "\(story!.timeLimit!)")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#NUMPARTICIPANTS#", with: "\(story!.participants)")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#NUMTURNS#", with: "\(story!.totalTurns!)")
            HTMLContent = HTMLContent.replacingOccurrences(of: "#PROMPT#", with: story!.prompt!)
            
            return HTMLContent
        }
        
        catch {
            print("Unable to open and use HTML template files.")
        }
        
        return nil
    }
    
    func exportHTMLContentToPDF(HTMLContent: String) {
        let printPageRenderer = CustomPrintPageRenderer()
        let printFormatter = UIMarkupTextPrintFormatter(markupText: HTMLContent)
        printPageRenderer.addPrintFormatter(printFormatter, startingAtPageAt: 0)
        
        let pdfData = drawPDFUsingPrintPageRenderer(printPageRenderer: printPageRenderer)
        
        pdfFilename = "\(AppDelegate.getAppDelegate().getDocDir())/\(story!.id).pdf"
        pdfData?.write(toFile: pdfFilename, atomically: true)
        
        print(pdfFilename)
    }
    
    func drawPDFUsingPrintPageRenderer(printPageRenderer: UIPrintPageRenderer) -> NSData! {
        let data = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        
        UIGraphicsBeginPDFPage()
        
        printPageRenderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        
        UIGraphicsEndPDFContext()
        
        return data
    }

    func uploadToS3(filepath: String) {
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
        uploadRequest?.body = URL(fileURLWithPath: filepath)
        
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
}
