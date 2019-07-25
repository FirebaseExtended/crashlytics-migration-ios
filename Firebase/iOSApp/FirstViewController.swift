//        Copyright 2019 Google LLC
//
//        Licensed under the Apache License, Version 2.0 (the "License");
//        you may not use this file except in compliance with the License.
//        You may obtain a copy of the License at
//
//        https://www.apache.org/licenses/LICENSE-2.0
//
//        Unless required by applicable law or agreed to in writing, software
//        distributed under the License is distributed on an "AS IS" BASIS,
//        WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//        See the License for the specific language governing permissions and
//        limitations under the License.

//
//  FirstViewController.swift
//  sample1
//
//

import UIKit
import Crashlytics

class FirstViewController: UIViewController {
    
    @IBOutlet var tapticButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for button in tapticButtons {
            button.layer.cornerRadius = button.frame.size.height/2
        }
    }
    
    @IBAction func setUserIDPressed(_ sender: Any) {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        //Fabric and Firebase set user email
        Crashlytics.sharedInstance().setUserEmail("test@email.com")
    }
    
    @IBAction func setCustomLogsPressed(_ sender: Any) {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        //Fabric and Firebase set custom logs
        CLSLogv("Log awesomeness %d %d %@", getVaList([1, 2, "three"]))
    }
    
    @IBAction func setCustomKeysPressed(_ sender: Any) {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        //Fabric and Firebase set custom keys
        Crashlytics.sharedInstance().setIntValue(42, forKey: "MeaningOfLife")
        Crashlytics.sharedInstance().setObjectValue("Test value", forKey: "last_UI_action")

    }
    @IBAction func crashButtonPressed(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
        
        //Fabric and Firebase test crash
        Crashlytics.sharedInstance().crash()
    }
    @IBAction func sendNonFatalPressed(_ sender: Any) {
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
        
        let userInfo: NSDictionary = [NSLocalizedDescriptionKey: NSLocalizedString("The request failed.", comment: "Description Key"),
                                      NSLocalizedFailureReasonErrorKey: NSLocalizedString("The response returned a 404.", comment: "Failure Reason"),
                                      NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("Does this page exist?", comment: "Recovery Suggestion"),
                                      "ProductID": "123456",
                                      "UserID": "John Doe"]
        let error: NSError = NSError(domain: "New Non-Fatal", code: -1001, userInfo: userInfo as? [String : Any])
        
        //Fabric and Firebase send non-fatal exception
        Crashlytics.sharedInstance().recordError(error)
    }
}

