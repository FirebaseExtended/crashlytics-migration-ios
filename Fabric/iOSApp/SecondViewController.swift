//Copyright 2019 Google LLC
//
//Licensed under the Apache License, Version 2.0 (the "License");
//you may not use this file except in compliance with the License.
//You may obtain a copy of the License at
//
//https://www.apache.org/licenses/LICENSE-2.0
//
//Unless required by applicable law or agreed to in writing, software
//distributed under the License is distributed on an "AS IS" BASIS,
//WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//See the License for the specific language governing permissions and
//limitations under the License.


//
//  SecondViewController.swift
//  sample1
//
//

import UIKit
import Crashlytics

class SecondViewController: UIViewController, UITextFieldDelegate {

    var activeTextField: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet var tapticButtons: [UIButton]!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        for button in tapticButtons {
            button.layer.cornerRadius = button.frame.size.height/2
        }
        
        registerForKeyboardNotifications()
        textField.delegate = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        deregisterForKeyboardNotification()
    }

    func registerForKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func deregisterForKeyboardNotification() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    @objc func keyboardWasShown(notification: NSNotification) {
        
        self.scrollView.isScrollEnabled = true
        
        var userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize!.height, right: 0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var frameRect: CGRect = self.view.frame
        frameRect.size.height -= keyboardSize!.height
        if let activeField = self.activeTextField {
            let activeOrigin =  activeField.frame.origin
            if frameRect.contains(activeOrigin) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification) {
        
        var userInfo = notification.userInfo!
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -keyboardSize!.height, right: 0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        self.view.endEditing(true)
        
        self.scrollView.isScrollEnabled = false
    }
    
    //TextField Delegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        //Fabric Answers for logSearch
        if let searchKeyword = self.textField.text {
            
            Answers.logSearch(withQuery: searchKeyword,
                                       customAttributes: nil)
        } else {
            Answers.logSearch(withQuery: "All",
                              customAttributes: nil)
        }
    }
    
    
    @IBAction func appleAddToCartButtonPressed(_ sender: Any) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        //Fabric Answers for logAddToCart
        Answers.logAddToCart(withPrice: 1.50,
                                      currency: "USD",
                                      itemName: "Answers Apple",
                                      itemType: "Fruit",
                                      itemId: "sku-100",
                                      customAttributes: nil)
    }
    
    
    @IBAction func pearAddToCartButtonPressed(_ sender: Any) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        //Fabric Answers for logAddToCart
        Answers.logAddToCart(withPrice: 2.50,
                             currency: "USD",
                             itemName: "Answers Pear",
                             itemType: "Fruit",
                             itemId: "sku-200",
                             customAttributes: nil)
    }
    
    @IBAction func orangeAddToCartButtonPressed(_ sender: Any) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        //Fabric Answers for logAddToCart
        Answers.logAddToCart(withPrice: 1.00,
                             currency: "USD",
                             itemName: "Answers Orange",
                             itemType: "Fruit",
                             itemId: "sku-300",
                             customAttributes: nil)
    }
    
    @IBAction func purchaseEventBtnPressed(_ sender: Any) {
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        //Fabric Answers for logPurchase
        Answers.logPurchase(withPrice: 30,
                            currency: "USD",
                            success: true,
                            itemName: "Fruit Basket",
                            itemType: "Fruits",
                            itemId: "APO-3",
                            customAttributes: nil)
    }
}

