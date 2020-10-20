//
//  Alarm.swift
//  AlarmClock
//
//  Created by Dauren on 10/20/20.
//  Copyright © 2020 Dauren. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    //PROPERTIES
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateView()
        }
    }
    var alarmIsOn = true
    

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enableButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewComponents()
    }
    


    
    private func updateView() {
        if let alarm = alarm {
            alarmIsOn = alarm.alarmEnabled
            datePicker.date = alarm.fireDate
            nameTextField.text = alarm.alarmName
            navigationItem.title = alarm.alarmName
        } else {
            navigationItem.title = "Создать будильник"
        }
    }
    
    func setViewComponents() {
        view.backgroundColor = .black
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        nameTextField.backgroundColor = #colorLiteral(red: 0.2004078329, green: 0.1992231905, blue: 0.201322794, alpha: 1)
        nameTextField.textColor = .white
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Введите название",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    

    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let alarmName = nameTextField.text
            else { return }
        if let alarm = alarm {
            AlarmController.sharedInstance.updateAlarmOfType(alarm: alarm, with: alarmName, fireDate: datePicker.date, isEnabled: alarmIsOn)
        } else {
            AlarmController.sharedInstance.addAlarmWith(fireDate: datePicker.date, name: alarmName, isEnabled: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
}
