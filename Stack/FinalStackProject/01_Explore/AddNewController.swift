//
//  AddCustomItemController.swift
//  FinalStackProject
//
//  Created by 김기윤 on 09/11/2017.
//  Copyright © 2017 younari. All rights reserved.
//

import UIKit

enum StackDetailType {
    case Add
    case Edit
}

class AddNewController: UIViewController, UITextFieldDelegate, RouterProtocol {
    
    static var storyboardName: String = "Main"
    
    var type: StackDetailType = .Add
    var name: String?
    var descriptions: String?
    var selectedStackData: Stack?

    var firstBillingDate: Date? {
        guard let date = billDateLabel.text else { return nil }
        let formatter = DateFormatter()
        let convertedDate = formatter.makeDate(with: date)
        return convertedDate
    }
    
    var planCycleType: PlanType? {
        guard let type = cycleLabel.text else { return nil }
        let planType = PlanType(rawValue: type)
        return planType
    }
    
    
    
    var popAnimator: PopAnimator?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var topTitleView: UIView!
    @IBOutlet weak var billDateLabel: UILabel!
    @IBOutlet weak var priceTextLabel: UILabel!
    @IBOutlet weak var cycleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let data = selectedStackData {
            configureUI(data: data)
        }
        configureTextFields()
        configureButton()
        
        self.popAnimator = PopAnimator(animationType: .up, tagetViewController: self, tagetView: self.topTitleView)
    }
    
    func configureButton() {
        switch type {
        case .Add:
            saveButton.setTitle("Add", for: .normal)
        case .Edit:
            saveButton.setTitle("Edit", for: .normal)
        }
    }
    
    func configureTextFields() {
        self.nameTextField.text = name
        self.descriptionTextView.text = descriptions
        nameTextField.isEnabled = false
        descriptionTextView.isEditable = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func configureUI(data: Stack) {
        name = data.title
        priceTextLabel.text = "\(data.price)"
        cycleLabel.text = data.planType.rawValue
        billDateLabel.text = data.date.string()
    }
    
    @IBAction func didTapClose(_ sender: UIButton) {
        self.popVC()
    }
    
    @IBAction func didTapSaveBtn(_ sender: UIButton) {
        guard let name = nameTextField.text else { return }
        guard let date = firstBillingDate else { return }
        guard let planType = planCycleType else { return }
        guard let priceText = priceTextLabel.text, let price = Float(priceText) else { return }
        let newStack = Stack(title: name, planType: planType, date: date, price: price)
        
        switch type {
        case .Add:
            GlobalState.shared.addStack(stack: newStack)
            self.popVC()
            
        case .Edit:
            guard let selectedStack = selectedStackData else { return }
            var filteredStacks = GlobalState.shared.savedStacks.filter { $0 != selectedStack }
            filteredStacks.append(newStack)
            GlobalState.shared.savedStacks = filteredStacks
            self.popVC()
        }
        
        NotificationCenter.default.post(name: .newStack, object: nil)
    }
}

extension AddNewController {
    
    @IBAction func didTapPriceTextField(_ sender: UIButton) {
        let alert = UIAlertController(style: .alert, title: "Payment Plan")
        let config: TextField.Config = { [weak self] textField in
            guard let `self` = self else { return }
            textField.becomeFirstResponder()
            textField.textColor = .black
            textField.placeholder = "9.99"
            //textField.left(image: UIImag, color: .black)
            textField.leftViewPadding = 12
            textField.borderWidth = 1
            textField.cornerRadius = 8
            textField.borderColor = UIColor.lightGray.withAlphaComponent(0.5)
            textField.backgroundColor = nil
            textField.keyboardAppearance = .default
            textField.keyboardType = .default
            textField.isSecureTextEntry = false
            textField.returnKeyType = .done
            textField.action { [weak self] textField in
                guard let `self` = self else { return } // validation
                guard let userTyped = textField.text, let price = userTyped.convertPriceFormat() else { return }
                self.priceTextLabel.text = price
                self.priceTextLabel.textColor = #colorLiteral(red: 0.26, green: 0.47, blue: 0.96, alpha: 1)
            }
        }
        alert.addOneTextField(configuration: config)
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    

    @IBAction func didTapDatePicker(_ sender: UIButton) {
        let alert = UIAlertController(style: .actionSheet, title: "Payment date")
        alert.addDatePicker(mode: .date, date: Date()) { [weak self] date in
            guard let `self` = self else { return }
            self.billDateLabel.text = date.string()
            self.billDateLabel.textColor = #colorLiteral(red: 0.26, green: 0.47, blue: 0.96, alpha: 1)
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    @IBAction func didTapCyclePicker(_ sender: UIButton) {
        let alert = UIAlertController(style: .actionSheet, title: "Payment Cycle", message: "How often do you pay?")
        let pickerViewValues: [[String]] = [[PlanType.monthly.rawValue, PlanType.yearly.rawValue]]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { [weak self] vc, picker, index, values in
            guard let `self` = self else { return }
            self.cycleLabel.text = values[index.column][index.row]
            self.cycleLabel.textColor = #colorLiteral(red: 0.26, green: 0.47, blue: 0.96, alpha: 1)
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }
    
}

extension AddNewController: NavigationAnimatorAble {
    var pushAnimation: PushAnimator? {
        return PushAnimator(animationType: .up)
    }
    var popAnimation: PopAnimator? {
        return self.popAnimator
    }
}

