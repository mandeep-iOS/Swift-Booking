//
//  PersonSelectionTextField.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import UIKit

class PersonSelectionTextField: UITextField, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let picker = UIPickerView()
    
    var numberOfPersons: Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set the text field's input view to the picker
        picker.delegate = self
        picker.dataSource = self
        self.inputView = picker
        
        // Add a toolbar with a Done button to the picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(pickerDoneButtonPressed))
        toolbar.items = [doneButton]
        self.inputAccessoryView = toolbar
    }
    
    // MARK: - Picker View Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10 // Set the maximum number of persons to 10, adjust as needed
    }
    
    // MARK: - Picker View Delegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1) person" // Display "1 person", "2 persons", etc.
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberOfPersons = row + 1 // Update the number of persons when the picker selection changes
    }
    
    @objc func pickerDoneButtonPressed() {
        // Set the text field's text to the selected number of persons
        self.text = "\(numberOfPersons) person"
        self.endEditing(true)
    }
}
