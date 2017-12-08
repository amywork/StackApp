//
//  AddCustomItemController.swift
//  FinalStackProject
//
//  Created by 김기윤 on 09/11/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit

class AddNewController: UIViewController, UITextFieldDelegate, PickerContainerControllerDelegate {
    
    
    
    @IBOutlet weak var nameTextField: UITextField! // name
    @IBOutlet weak var priceTextField: UITextField! // price
    
    @IBOutlet weak var containerPickerView: UIView!
    
    @IBOutlet weak var firstBillTexField: UITextField!
    @IBOutlet weak var cycleTextView: UITextView!
    @IBOutlet weak var cyclePicker: UIPickerView!
   
    @IBAction func didTapSaveBtn(_ sender: UIButton) {
//        guard let name = nameTextField.text, !name.isEmpty else { return }
//        let payDay: Date = payDayPicker.date
//        let planType: PlanType = monthlyBtn.isSelected ? PlanType.monthly : PlanType.yearly
//        let price: Float = Float(priceTextField.text!) ?? 0.0
//
//        let newStack = Stack(title: name, planType: planType, date: payDay, price: price)
//        DataManager.shared.addStack(newStack)
//
//        NotificationCenter.default.post(name: Notification.Name.newStack, object: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapFirstBillTextField(_ sender: UITextField) {
        containerPickerView.isHidden = false
        firstBillTexField.isEnabled = false
    }
    
    func didSelectedDate(_ date: Date) {
        firstBillTexField.text = date.string()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerPickerView.isHidden = true
    }
    
    // Edit Later
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickerContainerController" {
            let destination = segue.destination as! PickerContainerController
            destination.delegate = self
        }
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
        self.removeFromParentViewController()
    }
    
}
