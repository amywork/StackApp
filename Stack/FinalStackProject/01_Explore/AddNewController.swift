//
//  AddCustomItemController.swift
//  FinalStackProject
//
//  Created by 김기윤 on 09/11/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit

class AddNewController: UIViewController, UITextFieldDelegate, PickerContainerControllerDelegate, cyclePickerControllerDelegate {

    var name: String?
    var descriptions: String?
    var selectedDate: Date?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var priceTextField: UITextField! // price
    
    @IBOutlet weak var firstBillPickerView: UIView!
    @IBOutlet weak var firstBillTexField: UITextField!
    
    @IBOutlet weak var cyclePickerView: UIView!
    @IBOutlet weak var cycleTexField: UITextField!
  
    @IBAction func didTapSaveBtn(_ sender: UIButton) {
        guard let name = name else { return }
        guard let date = selectedDate else { return }
        let planType: PlanType = PlanType.yearly
        let price: Float = 10.99
        let newStack = Stack(title: name, planType: planType, date: date, price: price)
        App.api.uploadStacks(data: newStack) { (isSuccess) in
            if isSuccess {
                print("성공성공")
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
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
    
    @IBAction func didTapFirstBillTextField(_ sender: UITextField) {
        firstBillPickerView.isHidden = false
        firstBillTexField.isEnabled = false
    }
    
    func didSelectedDate(_ date: Date) {
        firstBillTexField.text = date.string()
        firstBillPickerView.isHidden = true
        firstBillTexField.isEnabled = true
        selectedDate = date
    }
    
    @IBAction func didTapCycleTexField(_ sender: UITextField) {
        cyclePickerView.isHidden = false
        cycleTexField.isEnabled = false
    }

    func didSelectedType(_ type: String) {
        cycleTexField.text = type
        cyclePickerView.isHidden = true
        cycleTexField.isEnabled = true
    }

}

protocol PickerContainerControllerDelegate {
    func didSelectedDate(_ date: Date)
}

class PickerContainerController: UIViewController {
   
    @IBOutlet weak var firstBillPicker: UIDatePicker!
    
    var delegate: PickerContainerControllerDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate?.didSelectedDate(firstBillPicker.date)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.didSelectedDate(firstBillPicker.date)
    }
    
    @IBAction func donBtnHandler(_ sender: UIButton) {
        delegate?.didSelectedDate(firstBillPicker.date)
    }
    
}


protocol cyclePickerControllerDelegate {
    func didSelectedType(_ type: String)
}

class cyclePickerController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: cyclePickerControllerDelegate?
    
    @IBOutlet weak var cyclePicker: UIPickerView!
    
    private var type: String = ""
 
    @IBAction func donBtnHandler(_ sender: UIButton) {
        delegate?.didSelectedType(type)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cyclePicker.dataSource = self
        cyclePicker.delegate = self
        delegate?.didSelectedType(type)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return PlanType.monthly.rawValue
        }else if row == 1 {
            return PlanType.yearly.rawValue
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == 0 {
            delegate?.didSelectedType(PlanType.monthly.rawValue)
        }else if row == 1 {
           delegate?.didSelectedType(PlanType.yearly.rawValue)
        }
    }
    
}
