//
//  Alarm.swift
//  AlarmClock
//
//  Created by Dauren on 10/20/20.
//  Copyright © 2020 Dauren. All rights reserved.
//

import UIKit


protocol SwitchCellDelegate: class {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    
    
    weak var cellDelegate: SwitchCellDelegate?
    
    var alarm: Alarm? {
        didSet {
            guard let alarm = alarm else { return }
            updateViews(alarm: alarm)
        }
    }
    

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    

    func updateViews(alarm: Alarm) {
        timeLabel.text = alarm.fireTimeAsString
        nameLabel.text = alarm.alarmName
        alarmSwitch.isOn = alarm.alarmEnabled
        if alarmSwitch.isOn == true {
            nameLabel.textColor = .white
            timeLabel.textColor = .white
        } else {
            nameLabel.textColor = .lightGray
            timeLabel.textColor = .lightGray
        }
    }
    

    @IBAction func switchValueChanged(_ sender: UISwitch) {
        cellDelegate?.switchCellSwitchValueChanged(cell: self)
    }
}
