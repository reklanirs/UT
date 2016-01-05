//
//  ViewController.swift
//  UT
//
//  Created by reKlanirs on 1/4/16.
//  Copyright © 2016 Rewrite. All rights reserved.
//

import UIKit
import Alamofire
import Kanna

class ViewController: UIViewController, UIPickerViewDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var input: UITextView!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBOutlet weak var gg_output: UITextView!
    
    @IBOutlet weak var bg_output: UITextView!
    
    @IBOutlet weak var bd_output: UITextView!
    
    @IBOutlet weak var yd_output: UITextView!
    
    
    var transource:String = ""
    let gg_dict = ["auto","zh-CN","en","ja","fr"]
    let bg_dict = ["","zh-CHS","en","ja","fr"]
    let bd_dict = ["auto","zh","en","jp","fra"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.input.layer.borderColor = UIColor.grayColor().CGColor
        self.input.layer.cornerRadius = 6
        self.input.layer.borderWidth = 1.2
        self.input.text = "input here"
        
        frame_init()
        
        let image = UIImage(contentsOfFile: "resource/test.jpg")
        let imageview = UIImageView(image: image)
        self.view.addSubview(imageview)
        
        let myView = UIView.init(frame: CGRectMake(0,0,320,568))
        let bgImgView = UIImageView.init(frame: CGRectMake(0,0,320,568))
        
        myView.addSubview(imageview)
        myView.sendSubviewToBack(imageview)
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
    
    var lang = ["自动","中","英","日","法"]
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        return lang.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lang[row]
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        transAll()
        return true
    }
    
    
    func frame_init(){
        self.gg_output.layer.borderColor = UIColor.grayColor().CGColor
        self.gg_output.layer.cornerRadius = 6
        self.gg_output.layer.borderWidth = 1.0
        self.gg_output.text = ""
        
        self.bg_output.layer.borderColor = UIColor.grayColor().CGColor
        self.bg_output.layer.cornerRadius = 6
        self.bg_output.layer.borderWidth = 1.0
        self.bg_output.text = ""
        
        self.bd_output.layer.borderColor = UIColor.grayColor().CGColor
        self.bd_output.layer.cornerRadius = 6
        self.bd_output.layer.borderWidth = 1.0
        self.bd_output.text = ""
        
        self.yd_output.layer.borderColor = UIColor.grayColor().CGColor
        self.yd_output.layer.cornerRadius = 6
        self.yd_output.layer.borderWidth = 1.0
        self.yd_output.text = ""
    }
    
    func transAll(){
        frame_init()
        
        transource = input.text

        let l0 = picker.selectedRowInComponent(0), l1 = picker.selectedRowInComponent(1)
        
        gg_test(gg_dict[l0], tl: gg_dict[l1])
        
        if(l1 == 0){
            bg_test(bg_dict[l0], tl: bg_dict[1])
        }else{
            bg_test(bg_dict[l0], tl: bg_dict[l1])
        }
        
        bd_test(bd_dict[l0], tl: bd_dict[l1])
        
        if(l1 <= 2){
            yd_test()
        }
    }
    
    
    
    func gg_test(sl: String = "auto", tl: String = "auto"){
        let url_gg = "http://translate.google.cn/"
        var payload_gg = [
            "q": "",
            "sl": sl,
            "tl": tl,
        ]
        payload_gg["q"] = transource
        Alamofire.request(.GET, url_gg, parameters: payload_gg)
            .responseString { response in
                print("Success: \(response.result.isSuccess)")
                //print("Response String: \(response.result.value)")
                if let doc = Kanna.HTML(html: response.result.value!, encoding: NSUTF8StringEncoding) {
                    print(doc.title)
                    
                    for link in doc.css("span") {
                        print(link.text)
                        print(link["href"])
                    }
                    print("haha" + doc.css("span")[2].text!)
                    self.gg_output.layer.borderColor = UIColor.blueColor().CGColor
                    self.gg_output.layer.cornerRadius = 6
                    self.gg_output.layer.borderWidth = 1.5
                    self.gg_output.text = doc.css("span")[2].text
                    
                    
                }
                
        }
    }
    
    func bg_test(sl: String = "", tl: String = "zh-CHS"){
        let url_tok = "https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"
        let payload_tok = ["client_id":"UT","client_secret":"xvtxxrbgurXf1EyMS8Ao9d71PLSXH7IlFEsC5v3os84=","scope":"http://api.microsofttranslator.com","grant_type":"client_credentials"]
        Alamofire.request(.POST, url_tok, parameters: payload_tok)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let authToken = "Bearer" + " " +  (JSON["access_token"] as! String)
                    let url_bg = "http://api.microsofttranslator.com/V2/Http.svc/Translate"
                    var payload_bg = ["from":sl,"to":tl,"appId":"","text":""]
                    payload_bg["text"] = self.transource
                    let headers_bg = ["Authorization":authToken]
                    
                    Alamofire.request(.GET, url_bg, parameters: payload_bg, headers: headers_bg)
                        .responseString { response in
                            print("Success: \(response.result.isSuccess)")
                            print("Response String: \(response.result.value)")
                            if let doc = Kanna.HTML(html: response.result.value!, encoding: NSUTF8StringEncoding) {
                                print(doc.body?.text)
                                self.bg_output.layer.borderColor = UIColor.yellowColor().CGColor
                                self.bg_output.layer.cornerRadius = 6
                                self.bg_output.layer.borderWidth = 1.5
                                self.bg_output.text = doc.body?.text
                            }
                            
                    }
                }
        }
    }
    
    func bd_test(sl: String = "auto", tl: String = "auto"){
        let url_bd = "http://openapi.baidu.com/public/2.0/bmt/translate"
        var payload_bd = ["from": sl, "to": tl,
            "client_id": "p0hEWs1cTQvcAwCCY8UaoSUH", "q": ""]
        payload_bd["q"] = transource
        Alamofire.request(.GET, url_bd, parameters: payload_bd)
            .responseJSON { response in
                if let JSON = response.result.value {
                    //print(JSON)
                    let js = JSON["trans_result"]!![0]["dst"]
                    print(js)
                    
                    self.bd_output.layer.borderColor = UIColor.blackColor().CGColor
                    self.bd_output.layer.cornerRadius = 6
                    self.bd_output.layer.borderWidth = 1.5
                    self.bd_output.text = js as! String
                }
        }
    }
    
    func yd_test(){
        let url_yd = "https://fanyi.youdao.com/openapi.do"
        var payload_yd = ["keyfrom": "rewrite", "key": "1101148556",
            "type": "data", "doctype": "json", "version": "1.1", "q": ""]
        payload_yd["q"] = transource
        Alamofire.request(.GET, url_yd, parameters: payload_yd)
            .responseJSON { response in
                if let JSON = response.result.value {
                    let js = JSON["translation"]!![0]!
                    print(js)
                    
                    self.yd_output.layer.borderColor = UIColor.redColor().CGColor
                    self.yd_output.layer.cornerRadius = 6
                    self.yd_output.layer.borderWidth = 1.5
                    self.yd_output.text = js as! String
                }
        }
    }
    


}

