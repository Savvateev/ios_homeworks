//
//  LocalNotificationsService.swift
//  Navigation
//
//  Created by Pavel Savvateev on 26.10.2026.
//


import Foundation
import UserNotifications

final class LocalNotificationsService {

    private enum Constants {
        static let latestUpdatesIdentifier = "latestUpdatesDailyNotification"
        static let latestUpdatesText = "Посмотрите последние обновления"
        static let notificationHour = 05
        static let notificationMinute = 47
    }

    private let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
    }

    /// Запрашивает разрешение на уведомления и, если оно есть, регистрирует ежедневное уведомление в 19:00.
    func registeForLatestUpdatesIfPossible() {
        notificationCenter.requestAuthorization(options: [.sound, .badge, .alert]) { [weak self] granted, error in
            if let error = error {
                print("Ошибка запроса разрешения на уведомления: \(error.localizedDescription)")
                return
            }

            guard granted else {
                print("Пользователь не разрешил отправку уведомлений")
                return
            }

            self?.scheduleLatestUpdatesNotification()
        }
    }

    private func scheduleLatestUpdatesNotification() {
        let content = UNMutableNotificationContent()
        content.body = Constants.latestUpdatesText
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = Constants.notificationHour
        dateComponents.minute = Constants.notificationMinute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: Constants.latestUpdatesIdentifier,
            content: content,
            trigger: trigger
        )

        // Удаляем старое уведомление с тем же идентификатором, чтобы не было дублей
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [Constants.latestUpdatesIdentifier])

        notificationCenter.add(request) { error in
            if let error = error {
                print("Ошибка регистрации уведомления: \(error.localizedDescription)")
            }
        }
    }
}
