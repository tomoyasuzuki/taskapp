//
//  InputViewController.swift
//  taskapp
//
//  Created by 鈴木友也 on 2019/02/10.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {
    
    //テキストではtitleTextFieldだが自分はtextFieldなので気をつける
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
