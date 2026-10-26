import Foundation
import UserNotifications

final class LocalNotificationsService: NSObject, UNUserNotificationCenterDelegate {

    private enum Constants {
        static let latestUpdatesIdentifier = "latestUpdatesDailyNotification"
        static let testIdentifier = "latestUpdatesTestNotification"
        static let latestUpdatesText = "Посмотрите последние обновления"
        static let notificationHour = 19
        static let notificationMinute = 00
    }

    private let notificationCenter: UNUserNotificationCenter

    init(notificationCenter: UNUserNotificationCenter = .current()) {
        self.notificationCenter = notificationCenter
        super.init()
        // Делегат нужен, чтобы показывать баннер, когда приложение открыто
        notificationCenter.delegate = self
    }

    /// Запрашивает разрешение и, если оно есть, регистрирует ежедневное уведомление в 19:00.
    func registeForLatestUpdatesIfPossible() {
        notificationCenter.requestAuthorization(options: [.sound, .badge, .alert]) { [weak self] granted, error in
            if let error = error {
                print("Ошибка запроса разрешения: \(error.localizedDescription)")
                return
            }
            print("Разрешение на уведомления: \(granted)")
            guard granted else { return }
            self?.scheduleLatestUpdatesNotification()
            self?.printSettingsAndPending()
        }
    }

    private func scheduleLatestUpdatesNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Обновления"
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

        notificationCenter.removePendingNotificationRequests(withIdentifiers: [Constants.latestUpdatesIdentifier])
        notificationCenter.add(request) { error in
            if let error = error {
                print("Ошибка регистрации уведомления: \(error.localizedDescription)")
            } else {
                print("Ежедневное уведомление зарегистрировано на 19:00")
            }
        }
    }

    private func printSettingsAndPending() {
        notificationCenter.getNotificationSettings { settings in
            print("Статус: \(settings.authorizationStatus.rawValue), alert: \(settings.alertSetting.rawValue), lock screen: \(settings.lockScreenSetting.rawValue)")
        }
        notificationCenter.getPendingNotificationRequests { requests in
            print("Запланировано уведомлений: \(requests.count)")
            requests.forEach { print("- \($0.identifier), trigger: \(String(describing: $0.trigger))") }
        }
    }

    // MARK: - UNUserNotificationCenterDelegate

    /// Показывает баннер и звук, даже если приложение открыто
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound, .badge])
    }
}
