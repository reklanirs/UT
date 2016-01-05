//
//  ViewController.swift
//  UT
//
//  Created by reKlanirs on 1/4/16.
//  Copyright © 2016 Rewrite. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var input: UITextView!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var gg_output: UITextView!
    
    @IBOutlet weak var bg_output: UITextView!
    
    @IBOutlet weak var bd_output: UITextView!
    
    @IBOutlet weak var yd_output: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.input.layer.borderColor = UIColor.grayColor().CGColor
        self.input.layer.cornerRadius = 6
        self.input.layer.borderWidth = 1.0
        self.input.text = "input here"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    var lang = ["自动","中","英","日"]
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        return lang.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lang[row]
    }
    

}

