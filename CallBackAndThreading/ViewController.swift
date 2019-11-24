//
//  ViewController.swift
//  CallBackAndThreading
//
//  Created by PuNeet on 24/11/19.
//  Copyright © 2019 Puneet. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var userName = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
     //   getUser()
        getUser { (isSuccess, result, error) in
            if isSuccess{
                print("GET USERS BLOCK CALLED")
                guard let names = result as? [String] else{return}
                print(names)
                self.userName = names
                self.tableView.reloadData()
                print("RELOAD CALLED")

            }else if let error = error{
                print(error)
            }
        }
    }

    func getUser(completion: @escaping (Bool,Any?,Error?)-> Void ){
        print("GET USER FUNCTION")
        DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
            print("DISPATCH FINISH")
              guard let path = Bundle.main.path(forResource: "someJSON", ofType: "txt") else{return}
                     let url = URL(fileURLWithPath: path)
                    do{
                        let data  = try Data(contentsOf: url)
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            //            print(json)
                        guard let array = json as? [[String:Any]] else {return}
                        var arrNames = [String]()
                        for user in array{
                            guard let name = user["name"] as? String else{continue}
                            arrNames.append(name)
                        }
                      //  completion()
                        DispatchQueue.main.async {
                            completion(true,arrNames,nil)
                            
                        }
                       // print(arrNames)
                    }catch{
                        print(error )
                        DispatchQueue.main.async {
                            completion(false,nil,error)
                            
                        }
            }
              
        }
    }

}

extension ViewController: UITableViewDelegate,UITableViewDataSource{
//    public func numberOfSections(in tableView: UITableView) -> Int {
//       return 1
//    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userName.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = userName[indexPath.row]
        return cell
    }
}
