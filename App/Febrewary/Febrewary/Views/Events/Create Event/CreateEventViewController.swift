//
//  CreateEventViewController.swift
//  Febrewary
//
//  Created by Matthew Dias on 6/22/19.
//  Copyright © 2019 Matt Dias. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var isPourerSwitch: UISwitch!
    
    
    @IBOutlet weak var submitButton: UIButton!
    
    var allTextFields = [UITextField]()
    let datePicker = UIDatePicker()
    private(set) var event: Event?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.minimumDate = Date()
        
        allTextFields = [nameTextField, dateTextField, addressTextField]
        
        nameTextField.delegate = self
        dateTextField.delegate = self
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = UIToolbar().pickerAccessory(action: #selector(setDate))
        addressTextField.delegate = self

        submitButton.layer.cornerRadius = 8
    }
    
    // MARK: - Form
    func isValidateForm() -> Bool {
        return nameTextField.text != nil && nameTextField.text?.isEmpty == false &&
               dateTextField.text != nil && dateTextField.text?.isEmpty == false &&
               addressTextField.text != nil && addressTextField.text?.isEmpty == false
    }
    
    func showFormError() {
        let alert = UIAlertController(title: "Error", message: "All form fields are required.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func setDate() {
        dateTextField.text = datePicker.date.shortMonthDayYearWithTime
        _ = textFieldShouldReturn(dateTextField)
    }
    
    // MARK: - Networking
    func createEvent() {
        guard let name = nameTextField.text,
              let address = addressTextField.text,
              let date = dateTextField.text?.toDate() else { return }
        let isPourer = isPourerSwitch.isOn
        
        EventsService().createEvent(named: name,
                                    on: date,
                                    at: address,
                                    isPourer: isPourer) { (result) in
            switch result {
            case .success(let event):
                self.event = event
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "unwindToEventsList", sender: self)
                }
            case .failure(let error):
                // fail -> show error
                print(error)
            }
        }
    }

    // MARK: - Actions
    @IBAction func didTapClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSubmit(_ sender: Any) {
        if isValidateForm() {
            createEvent()
        } else {
            showFormError()
        }
    }
}

// MARK: - UITextFieldDelegate
extension CreateEventViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let id = allTextFields.firstIndex(where: { return $0 == textField }) else {
            return true
        }
        
        let nextId = allTextFields.index(after: id)
        
        if allTextFields.count > nextId {
            let nextfield = allTextFields[nextId]
            nextfield.becomeFirstResponder()
        } else if allTextFields.count == nextId, let lastfield = allTextFields.last {
            lastfield.resignFirstResponder()
        }
        
        return true
    }
}
