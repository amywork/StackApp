//
//  ListViewController.swift
//  1018_Fanxy
//
//  Created by 김기윤 on 20/10/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit

class ListMainController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var itemTableView: UITableView!
    lazy var stacks = GlobalState.shared.stakcs
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationItem.title = "My Stack"
        self.navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addController))
        
        NotificationCenter.default
            .addObserver(forName: .newStack, object: nil, queue: nil) { (noti) in
                self.stacks = GlobalState.shared.stakcs
                DispatchQueue.main.async {
                    self.itemTableView.reloadData()
                }
        }
    }
    
    //MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stacks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "✔︎ Your stack list"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    private var palette: [UIColor] = [#colorLiteral(red: 1, green: 0.1607843137, blue: 0.4078431373, alpha: 1),#colorLiteral(red: 0.26, green: 0.47, blue: 0.96, alpha: 1),#colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1),#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1),#colorLiteral(red: 0.3882352941, green: 0.8549019608, blue: 0.2196078431, alpha: 1),#colorLiteral(red: 0.8, green: 0.4509803922, blue: 0.8823529412, alpha: 1)]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomStackCell", for: indexPath) as! CustomStackCell
        cell.data = stacks[indexPath.row]
        let index = indexPath.row % 6
        cell.colorView.backgroundColor = palette[index]
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? CustomStackCell else { return }
        guard let nextVC = segue.destination as? ListDetailController else { return }
        nextVC.data = cell.data
    }
    
    @objc func addController() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AddCustomController")
        vc.navigationItem.title = "Add Custom"
        self.present(vc, animated: true, completion: nil)
    }
    
}

