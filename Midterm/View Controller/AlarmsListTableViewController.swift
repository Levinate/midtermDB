//
//  Alarm.swift
//  AlarmClock
//
//  Created by Dauren on 10/20/20.
//  Copyright © 2020 Dauren. All rights reserved.
//

import UIKit

class AlarmsListTableViewController: UITableViewController {
   

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
           print("Ok button tapped")
        })
        var dialogMessage = UIAlertController(title: "Confirm", message: "24 Часа прошло", preferredStyle: .alert)
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.sharedInstance.alarms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
        let alarmToDisplay = AlarmController.sharedInstance.alarms[indexPath.row]
        //set delegate
        cell.cellDelegate = self
        cell.updateViews(alarm: alarmToDisplay)
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var dialogMessage = UIAlertController(title: "Confirm", message: "Вы точно хотите удалить?", preferredStyle: .alert)
        
        // Create OK button with action handler
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
            print("Ok button tapped")
         })
        let cancel = UIAlertAction(title: "No", style: .cancel) { (action) -> Void in
            print("Cancel button tapped")
        }
        
        if editingStyle == .delete {
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            // Present Alert to
            self.present(dialogMessage, animated: true, completion: nil)

            let alarmToRemove = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.deleteAlarm(alarmToDelete: alarmToRemove)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmDetailViewController", let indexPath = tableView.indexPathForSelectedRow {
            let destinationVC = segue.destination as? AlarmDetailTableViewController
            let alarmToShow = AlarmController.sharedInstance.alarms[indexPath.row]
            destinationVC?.alarm = alarmToShow
        }
    }
}

//CONFORM TO PROTOCOL (Declared on Custom Cell for switch functionality)
extension AlarmsListTableViewController: SwitchCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
        AlarmController.sharedInstance.toggleEnabled(for: alarm)
        cell.updateViews(alarm: alarm)
    }
}
