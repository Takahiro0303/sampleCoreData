//
//  ViewController.swift
//  sampleCoreData
//
//  Created by takahiro tshuchida on 2017/09/18.
//  Copyright © 2017年 Takahiro Tshuchida. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var textTitle: UITextField!
    
    @IBOutlet weak var myTableView: UITableView!
    
    var contentTitle:[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        CoreDataからデータを読み込む処理
        read()
    }
    
//    CoreDateに保存されているデータの読み込み（READ）
    func read(){
    //AppDelegateを使う用意をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
    //エンティティを操作するためのオブジェクトを使用
        let viewContext = appD.persistentContainer.viewContext

        
    //どのエンティティからデータを取得してくるか設定
        let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()
        
    //データ一括取得
        do{
            //保存されているデータを全て(fetch)取得
            let fetchResults = try viewContext.fetch(query)
            
            //一件ずつ表示
            for result:AnyObject in fetchResults{
                let title:String? = result.value(forKey:"title") as? String
                let saveDate:Date? = result.value(forKey:"saveDate") as? Date
                
                print("title:\(title!) saveDate:\(saveDate)")
                
                contentTitle.append(title as! String)
            }
        }catch{
        }
    }
    
//   tableView設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = contentTitle[indexPath.row]
        return cell
    }
    
//    リターンキーが押された時（キーボードを閉じる）
    @IBAction func tapReturn(_ sender: UITextField) {
    }

//    追加ボタンが押された時(CREATEに当たる処理)
    @IBAction func tapAdd(_ sender: UIButton) {
    }
    

//    全削除ボタンが押された時(DELETEに当たる処理)
    @IBAction func tapDelete(_ sender: Any) {
        
        //AppDelegateを使う用意をしておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
        //エンティティを操作するためのオブジェクトを使用
        let viewContext = appD.persistentContainer.viewContext
        
        
        //どのエンティティからデータを取得してくるか設定
        let query:NSFetchRequest<ToDo> = ToDo.fetchRequest()

        //データを一括取得
        do{
        let fetchRequests = try viewContext.fetch(query)
        
        for result:AnyObject in fetchRequests{
        //取得したデータを指定し、削除
            let record = result as! NSManagedObject
            viewContext.delete(record)
        }
        
        //削除した状態を保存
        try viewContext.save()
        }catch{
        }
    

        
        
    }
    
    
    

    @IBAction func tapSave(_ sender: UIButton) {
        //AppDelegateを使う用意をいておく
        let appD:AppDelegate = UIApplication.shared.delegate as!AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appD.persistentContainer.viewContext
        
        //ToDoエンティティオブジェクトを作成
        let ToDo = NSEntityDescription.entity(forEntityName: "ToDo", in: viewContext)
        
        //ToDoエンティティにレコード（行）を購入するためのオブジェクトを作成
        let newRecord = NSManagedObject(entity: ToDo!, insertInto: viewContext)
        
        //値のセット(アトリビュート毎に指定)forkeyはモデルで指定したアトリビュート名
        //Date()は、現在日時を取得する関数
        newRecord.setValue(textTitle.text, forKey: "title")
        newRecord.setValue(Date(), forKey: "saveDate")
        
        //レコード（行）の即時保存
//        例外表示の書き方
        do{
            try viewContext.save()
        }catch{
        
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//TODO
//1.取得したdataを配列に保存する
//2.titleのみ表示
//3.reloadDataで再描画（TableView + reloadDataでググって調べておきましょう）

