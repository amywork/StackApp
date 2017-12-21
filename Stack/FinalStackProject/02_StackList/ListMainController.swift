//
//  ListViewController.swift
//  1018_Fanxy
//
//  Created by 김기윤 on 20/10/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit
var palette: [UIColor] = [#colorLiteral(red: 1, green: 0.1607843137, blue: 0.4078431373, alpha: 1),#colorLiteral(red: 0.26, green: 0.47, blue: 0.96, alpha: 1),#colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1),#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1),#colorLiteral(red: 0.3882352941, green: 0.8549019608, blue: 0.2196078431, alpha: 1),#colorLiteral(red: 0.8, green: 0.4509803922, blue: 0.8823529412, alpha: 1)]

class ListMainController: UIViewController {
    
    @IBOutlet weak var itemTableView: UITableView!
    lazy var stacks = GlobalState.shared.stakcs
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "My Stack"
        /*self.navigationController?.navigationItem.rightBarButtonItem
            = UIBarButtonItem(barButtonSystemItem: .add,
                              target: self,
                              action: #selector(addController))*/
        
        NotificationCenter.default
            .addObserver(forName: .newStack, object: nil, queue: nil) { (noti) in
                self.stacks = GlobalState.shared.stakcs
                DispatchQueue.main.async {
                    self.itemTableView.reloadData()
                }
        }
    }
    
    
}

extension ListMainController: UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stacks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "You are now subscribing..."
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomStackCell", for: indexPath) as! CustomStackCell
        cell.data = stacks[indexPath.row]
        let index = indexPath.row % 6
        cell.colorView.backgroundColor = palette[index]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default,
                                                title: "Delete",
                                                handler: { (action , indexPath) -> Void in
            // Deleting Cell
        })
        
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddNewController") as! AddNewController
        let cancelBtn = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dissmissEditController))
        cancelBtn.tintColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0.4078431373, alpha: 1)
        let navi = UINavigationController(rootViewController: vc)
        vc.navigationItem.title = "Edit Stack"
        vc.navigationItem.rightBarButtonItem = cancelBtn
        let selectedStack = stacks[indexPath.row]
        vc.selectedStackData = selectedStack
        vc.type = .Edit
        self.present(navi, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func dissmissEditController() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension ListMainController {
    /* Add Custom
    @objc func addController() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddCustomController")
        vc.navigationItem.title = "Add Custom"
        self.present(vc, animated: true, completion: nil)
    }
     */
}
