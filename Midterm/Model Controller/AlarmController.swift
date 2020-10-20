//
//  Alarm.swift
//  AlarmClock
//
//  Created by Dauren on 10/20/20.
//  Copyright © 2020 Dauren. All rights reserved.
//

import Foundation
import UserNotifications


protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}


class AlarmController {
    

    static let sharedInstance = AlarmController()
    

    var alarms = [Alarm]()
    
    init() {
        loadFromPersistentStore()
    }

    func addAlarmWith(fireDate: Date, name: String, isEnabled: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, alarmName: name, alarmEnabled: isEnabled)
        alarms.append(newAlarm)
        saveToPersistentStore()
        if newAlarm.alarmEnabled {
            scheduleUserNotifications(for: newAlarm)
        } else { return }
    }
    
    func updateAlarmOfType(alarm: Alarm, with oldName: String, fireDate: Date, isEnabled: Bool) {
        alarm.alarmName = oldName
        alarm.fireDate = fireDate
        alarm.alarmEnabled = isEnabled
        saveToPersistentStore()
        if alarm.alarmEnabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
    }
    
    func deleteAlarm(alarmToDelete: Alarm) {
        if let alarmIndex = alarms.firstIndex(of: alarmToDelete) {
            alarms.remove(at: alarmIndex)
            saveToPersistentStore()
            cancelUserNotifications(for: alarmToDelete)
        }
    }
    
    func toggleEnabled(for alarm: Alarm) {
        alarm.alarmEnabled = !alarm.alarmEnabled
        if alarm.alarmEnabled {
            scheduleUserNotifications(for: alarm)
        } else {
            cancelUserNotifications(for: alarm)
        }
    }
    
 
    func saveToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(alarms)
            try data.write(to: fileURL())
        } catch let error {
            print("Error saving to persistent store: \(error.localizedDescription)")
        }
    }

    func loadFromPersistentStore() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedAlarms = try jsonDecoder.decode([Alarm].self, from: data)
            alarms = decodedAlarms
        } catch let error {
            print("Error loading from persistent store: \(error.localizedDescription)")
        }
    }

    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let fileName = "alarmClock.json"
        let url = documentDirectory.appendingPathComponent(fileName)
        return url
    }
}


extension AlarmController: AlarmScheduler {
    func scheduleUserNotifications(for alarm: Alarm) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = "Твой будильник"
        notificationContent.sound = .default
        
        let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        let request = UNNotificationRequest(identifier: alarm.uuid, content: notificationContent, trigger: notificationTrigger)
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
