//
//  DateTimeSelectionTextField.swift
//  Swift-Booking
//
//  Created by Deep Baath on 18/02/23.
//


import UIKit

class DateTimeSelectionTextField: UITextField {
    
    var datePicker = UIDatePicker()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set the text field's input view to the date picker
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        self.inputView = datePicker
        
        // Add a toolbar with a Done button to the date picker
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(datePickerDoneButtonPressed))
        toolbar.items = [doneButton]
        self.inputAccessoryView = toolbar
    }
    
    @objc func datePickerDoneButtonPressed() {
        // Set the text field's text to the selected date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        self.text = dateFormatter.string(from: datePicker.date)
        self.endEditing(true)
    }
}
