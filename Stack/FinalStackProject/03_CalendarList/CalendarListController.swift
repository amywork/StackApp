//
//  CalendarListController.swift
//  FinalStackProject
//
//  Created by Kimkeeyun on 13/12/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarListController: UIViewController, RouterProtocol {
    static var storyboardName: String = "Main"
    
    var stacks: [Stack] = GlobalState.shared.stakcs
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var tableView: UITableView!
    
    private var currentCalendar: Calendar?
    private var selectedDay: DayView!
    private var animationFinished: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentCalendar = currentCalendar {
            monthLabel.text = CVDate(date: Date(), calendar: currentCalendar).globalDescription
        }
        
        NotificationCenter.default
            .addObserver(forName: .newStack, object: nil, queue: nil) { (noti) in
                self.stacks = GlobalState.shared.stakcs
                DispatchQueue.main.async {
                    self.calendarView.reloadInputViews()
                    self.tableView.reloadData()
                }
        }
    }
    
    override func awakeFromNib() {
        let timeZoneBias = 480 // (UTC+08:00)
        currentCalendar = Calendar.init(identifier: .gregorian)
        currentCalendar?.locale = Locale(identifier: "en_US")
        if let timeZone = TimeZone.init(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
    }
    
    @IBAction func refreshMonth(sender: AnyObject) {
        calendarView.contentController.refreshPresentedMonth()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    
}

extension CalendarListController:
CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    func presentationMode() -> CalendarMode {
        return .monthView
    }

    func firstWeekday() -> Weekday {
        return .sunday
    }

    // MARK: Optional methods
    func calendar() -> Calendar? {
        return currentCalendar
    }

    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
        return weekday == .sunday ?
            UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0) : UIColor.black
    }

    func shouldShowWeekdaysOut() -> Bool {
        return true
    }

    func shouldAnimateResizing() -> Bool {
        return true
    }

    private func shouldSelectDayView(dayView: DayView) -> Bool {
        return true
    }

    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }

    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        selectedDay = dayView
        let newList = stacks.filter { (stack) -> Bool in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let stackStr = formatter.string(from: stack.date)
            let selectedStr = String(selectedDay.date.day)
            return stackStr == selectedStr
        }
        stacks = newList
        tableView.reloadData()
        stacks = GlobalState.shared.stakcs
    }

    func shouldSelectRange() -> Bool {
        return false
    }

    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center

            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)

            UIView.animate(withDuration: 0.35,
                           delay: 0,
                           options: .curveEaseIn,
                           animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0,
                                                              y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1,
                                                              y: 0.1)
                self.monthLabel.alpha = 0

                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity

            }) { _ in
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }

            self.view.insertSubview(updatedMonthLabel,
                                    aboveSubview: self.monthLabel)
        }
    }

    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return false
    }

    func weekdaySymbolType() -> WeekdaySymbolType {
        return .short
    }

    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }

    func shouldShowCustomSingleSelection() -> Bool {
        return false
    }

    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        circleView.fillColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        return circleView
    }

    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return false
    }

    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {

        dayView.setNeedsLayout()
        dayView.layoutIfNeeded()
        
        let π = Double.pi
        let ringLayer = CAShapeLayer()
        let ringLineWidth: CGFloat = 1.0
        let ringLineColour = UIColor.clear

        let newView = UIView(frame: dayView.frame)

        let diameter = (min(newView.bounds.width, newView.bounds.height))
        let radius = diameter / 12

        newView.layer.addSublayer(ringLayer)

        ringLayer.fillColor = #colorLiteral(red: 1, green: 0.1607843137, blue: 0.4078431373, alpha: 1)
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.cgColor

        let centrePoint = CGPoint(x: newView.bounds.width * 0.8, y: 8)
        let startAngle = CGFloat(-π/2.0)
        let endAngle = CGFloat(π * 2.0) + startAngle
        let ringPath = UIBezierPath(arcCenter: centrePoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)

        ringLayer.path = ringPath.cgPath
        ringLayer.frame = newView.layer.bounds

        return newView
    }

    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {

        guard let currentCalendar = currentCalendar else {
            return false
        }
        
        var components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar)

        /* For consistency, always show supplementaryView on the 3rd, 13th and 23rd of the current month/year.  This is to check that these expected calendar days are "circled". There was a bug that was circling the wrong dates. A fix was put in for #408 #411.

         Other month and years show random days being circled as was done previously in the Demo code.
         */
        
        var days: [Date] {
            return stacks.map { (stack) -> Date in
                return stack.date
            }
        }
        
        let mappingDays = days.map({ (date) -> Int in
            let formatter = DateFormatter()
            formatter.dateFormat = "dd"
            let dateStr = formatter.string(from: date)
            return Int(dateStr)!
        })
        
        if mappingDays.contains(dayView.date.day) {
            // 유저가 등록한 날짜일 경우
            return true
        }else {
            return false
        }

        /*
        if dayView.date.year == components.year &&
            dayView.date.month == components.month {

            if (dayView.date.day == 3 || dayView.date.day == 13 || dayView.date.day == 23)  {
                print("Circle should appear on " + dayView.date.commonDescription)
                return true
            }
            return false
        } else {
            return false
        }*/

    }

    func dayOfWeekTextColor() -> UIColor {
        return UIColor.white
    }

    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColor.white
    }

    func latestSelectableDate() -> Date {
        var dayComponents = DateComponents()
        dayComponents.day = 70
        let calendar = Calendar(identifier: .gregorian)
        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
            return lastDate
        } else {
            return Date()
        }
    }
}


// MARK: - CVCalendarViewAppearanceDelegate
extension CalendarListController: CVCalendarViewAppearanceDelegate {

    func dayLabelWeekdayDisabledColor() -> UIColor {
        return UIColor.gray
    }

    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return true
    }

    func spaceBetweenDayViews() -> CGFloat {
        return 4
    }

    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont { return UIFont.systemFont(ofSize: 14) }

}

// MARK: - TableView DataSource
extension CalendarListController: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stacks.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomStackCell", for: indexPath) as! CustomStackCell
        cell.data = stacks[indexPath.row]
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



