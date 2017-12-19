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

