//
//  InputViewController.swift
//  taskapp
//
//  Created by 鈴木友也 on 2019/02/10.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//
import UserNotifications
import UIKit
import RealmSwift

class InputViewController: UIViewController {
    
    //テキストではtitleTextFieldだが自分はtextFieldなので気をつける
    @IBOutlet weak var textField: UITextField!
   
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryTextField: UITextField!
    
    
    
    
    let realm = try! Realm()
    var task: Task!
    
    
    //作成・編集画面がロードされた直後に行う処理
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //背景をタップしたらdismissKeyBoardメソッドを呼ぶように設定する
        let tapGuesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        self.view.addGestureRecognizer(tapGuesture)
        
        //戻ってきた時にセルの内容を引き継ぐ。
        textField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        categoryTextField.text = task.category
        
        
        // 枠線の色
        
        
        
    }
    
    
    @objc func dismissKeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
    
    }
    
    
    @IBAction func catgWork(_ sender: Any) {
        
        categoryTextField.text = "work"
    }
    
    @IBAction func categHouse(_ sender: Any) {
        categoryTextField.text = "house_work"
    }
    
    @IBAction func categHobby(_ sender: Any) {
        categoryTextField.text = "hobby"
    }
    
    
    //作成・編集画面が消える直前に行う処理。
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write{
            self.task.title = self.textField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = self.categoryTextField.text!
            self.realm.add(self.task, update: true)
        }
        
        setNotification(task: task)
        super.viewWillDisappear(animated)
    }
    
    //タスクのローカル通知を登録する
    func setNotification(task: Task){
        let content = UNMutableNotificationContent()
        //タイトルの中身を設定
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        
        if task.contents == "" {
            content.body = "内容なし"
        } else {
            content.body = task.contents
        }
        
        
     
        
        
        content.sound = UNNotificationSound.default
        
        
        //ローカル通知が発動するトリガーを作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute],from: task.date)
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        
        //identfier ,content, trigger から通知を作成
         let request = UNNotificationRequest.init(identifier: String(task.id), content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request){(error) in
            print(error ?? "ローカル通知登録 OK") //errorがnilじゃないなら通知登録成功を通知、nilならerrorを表示
            
        }
        
        //未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests {(requests: [UNNotificationRequest]) in
            for request in requests {
                print("--------------")
                print(request)
                print("---------------/")
            }
        }
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
