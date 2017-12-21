//
//  AddCustomItemController.swift
//  FinalStackProject
//
//  Created by 김기윤 on 09/11/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit

class AddNewController: UIViewController, UITextFieldDelegate {
    
    var name: String?
    var descriptions: String?
    var selectedStackData: Stack?

    var firstBillingDate: Date? {
        guard let date = firstBillTexField.text else { return nil }
        let formatter = DateFormatter()
        let convertedDate = formatter.makeDate(with: date)
        return convertedDate
    }
    
    var planCycleType: PlanType? {
        guard let type = cycleTexField.text else { return nil }
        let planType = PlanType(rawValue: type)
        return planType
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var firstBillPickerView: UIView!
    @IBOutlet weak var firstBillTexField: UITextField!
    @IBOutlet weak var cyclePickerView: UIView!
    @IBOutlet weak var cycleTexField: UITextField!
  
    @IBAction func didTapSaveBtn(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        guard let date = firstBillingDate else { return }
        guard let planType = planCycleType else { return }
        let price: Float = 10.99
        let newStack = Stack(title: name, planType: planType, date: date, price: price)
        GlobalState.shared.addStack(stack: newStack)
        NotificationCenter.default.post(name: .newStack, object: nil)
        print("GlobalState.shared.addStack(stack: newStack)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = selectedStackData {
            configureUI(data: data)
        }
        cycleTexField.delegate = self
        firstBillTexField.tintColor = .clear
        cycleTexField.tintColor = .clear
        firstBillPickerView.isHidden = true
        cyclePickerView.isHidden = true
        self.nameTextField.text = name
        self.descriptionTextView.text = descriptions
        nameTextField.isEnabled = false
        descriptionTextView.isEditable = false
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        switch identifier {
        case "pickerContainerController":
            let destination = segue.destination as! PickerContainerController
            destination.delegate = self
        case "cycleContainerController":
            let destination = segue.destination as! cyclePickerController
            destination.delegate = self
        default:
            break
        }
    }
    
    func configureUI(data: Stack) {
        name = data.title
        priceTextField.text = "\(data.price)"
        cycleTexField.text = data.planType.rawValue
        firstBillTexField.text = data.date.string()
    }

}

extension AddNewController: PickerContainerControllerDelegate, cyclePickerControllerDelegate {
    
    @IBAction func didTapFirstBillTextField(_ sender: UITextField) {
        firstBillPickerView.isHidden = false
        firstBillTexField.isEnabled = false
    }
    
    @IBAction func didTapCycleTexField(_ sender: UITextField) {
        cyclePickerView.isHidden = false
        cycleTexField.isEnabled = false
    }
    
    func didSelectedPickerItem(_ date: Date) {
        firstBillTexField.text = date.string()
    }
    
    func didSelectedFirstBillDate() {
        firstBillPickerView.isHidden = true
        firstBillTexField.isEnabled = true
    }
    
    func didSelectedPickerItem(_ type: String) {
        cycleTexField.text = type
    }
    
    func didSelectedCycle() {
        cyclePickerView.isHidden = true
        cycleTexField.isEnabled = true
    }
    
}


protocol PickerContainerControllerDelegate {
    func didSelectedPickerItem(_ date: Date)
    func didSelectedFirstBillDate()
}

protocol cyclePickerControllerDelegate {
    func didSelectedPickerItem(_ type: String)
    func didSelectedCycle()
}

class PickerContainerController: UIViewController {
   
    @IBOutlet weak var firstBillPicker: UIDatePicker!
    
    var delegate: PickerContainerControllerDelegate?
    
    @IBAction func donBtnHandler(_ sender: UIButton) {
        delegate?.didSelectedPickerItem(firstBillPicker.date)
        delegate?.didSelectedFirstBillDate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.didSelectedPickerItem(firstBillPicker.date)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class cyclePickerController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var cyclePicker: UIPickerView!
    
    var delegate: cyclePickerControllerDelegate?
    let dataSource: [String] = [PlanType.monthly.rawValue, PlanType.yearly.rawValue]
    

    @IBAction func donBtnHandler(_ sender: UIButton) {
        let selectedRow = cyclePicker.selectedRow(inComponent: 0)
        let selectedType = dataSource[selectedRow]
        delegate?.didSelectedPickerItem(selectedType)
        delegate?.didSelectedCycle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cyclePicker.dataSource = self
        cyclePicker.delegate = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        delegate?.didSelectedPickerItem(dataSource[row])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
