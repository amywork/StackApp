//
//  CalendarViewController.swift
//
//  Created by 김기윤 on 08/11/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit
class CalendarViewController: UIViewController, CalendarViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    /*Filter*/
    var stacks: [Stack] = GlobalState.shared.stakcs
    
    func calendar(_ calendar: CalendarView, didSelectedDate date: Date) {
        let newList = stacks.filter { (stack) -> Bool in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let stackStr = formatter.string(from: stack.date)
            let selectedStr = formatter.string(from: date)
            return stackStr == selectedStr
        }
        stacks = newList
        tableView.reloadData()
        stacks = GlobalState.shared.stakcs
    }
    
    /*Calendar*/
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var thisMonthLabel: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        calendarView.date = Date()
        thisMonthLabel.title = "\(calendarView.year ?? 1). \(calendarView.month ?? 1)"
    }
    
    @IBAction func toNextMonth(_ sender: UIButton) {
        calendarView.updateNextMonth()
        thisMonthLabel.title = "\(calendarView.year ?? 1). \(calendarView.month ?? 1)"
    }
    
    @IBAction func toPrevMonth(_ sender: UIButton) {
        calendarView.updatePrevMonth()
        thisMonthLabel.title = "\(calendarView.year ?? 1). \(calendarView.month ?? 1)"
    }
    
}

private var palette: [UIColor] = [#colorLiteral(red: 1, green: 0.1607843137, blue: 0.4078431373, alpha: 1),#colorLiteral(red: 0.26, green: 0.47, blue: 0.96, alpha: 1),#colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1),#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1),#colorLiteral(red: 0.3882352941, green: 0.8549019608, blue: 0.2196078431, alpha: 1),#colorLiteral(red: 0.8, green: 0.4509803922, blue: 0.8823529412, alpha: 1)]

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stacks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomStackCell", for: indexPath) as! CustomStackCell
        cell.titleLabel.text = stacks[indexPath.row].title
        let index = indexPath.row % 6
        cell.colorView.backgroundColor = palette[index]
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Upcomings"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

