//
//  ViewController.swift
//  taskapp
//
//  Created by 鈴木友也 on 2019/02/10.
//  Copyright © 2019 tomoya.suzuki. All rights reserved.
//

import UserNotifications
import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Realmインスタンスを取得する
    let realm = try! Realm()  // ←追加
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var focusTextField: UITextField!
    
    // DB内のタスクが格納されるリスト。
    // 日付近い順\順でソート：降順
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)  // ←追加
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    
    
    // MARK: UITableViewDataSourceプロトコルのメソッド
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskArray.count
    }
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        //何番目のセルがか自動で取得（上で指定したデータの数だけ繰り返す）taskに代入
        let task = taskArray[indexPath.row]
        //セルのテキストを当該セルが持つtitleデータ代入
        cell.textLabel?.text = task.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    //各セルを選択した時に実行されるメソッド
    func tableView (_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "cellSegue", sender: nil)
        
    }
    
    
    //セルの削除が可能であることを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle{
        return .delete
        
        
    }
    
    
    //Deleteボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //削除するタスクを取得する
            let task = self.taskArray[indexPath.row]
            //ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
            
            
            //データベースから削除する
            try! realm.write {
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            //未通知の通知一覧をそログ出力
            center.getPendingNotificationRequests {(requests: [UNNotificationRequest] ) in
                for request in requests {
                    print("/---------------")
                    print(request)
                    print("---------------/")
                }
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
            
        } else {
            //ここは単純にインスタンスを生成しているだけ
            let task = Task()
            task.date = Date()
            
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
            inputViewController.task = task
        }
    }
    
    //タスク編集画面から戻ってきたときの処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
   
    @IBAction func doFocus(_ sender: Any) {
        if let  text = focusTextField.text {
            print(text)
            taskArray = realm.objects(Task.self).filter("category == %@", text)
        } else {
            print("nilです")
        }
        
        
        
        
        
        
        tableView.reloadData()
    }
    
    
    @IBAction func resetBtn(_ sender: Any) {
        taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: false)
        
        tableView.reloadData()
    }
    
    
    
}
