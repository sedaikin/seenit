//
//  SettingsScreenViewModel.swift
//  Seen it
//
//  Created by Rogova Mariya on 06.10.2025.
//

import SwiftUI
import Combine
import UserNotifications

final class SettingsScreenViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var userEmail: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var alertTitle: String = ""
    @Published var notificationsEnabled: Bool = false
    @Published var showSettingsAlert: Bool = false

    // MARK: - Private Properties
    private let userDefaultsKeys: UserDefaultsKeys
    private let notificationCenter = UNUserNotificationCenter.current()

    // MARK: - Computed Properties
    var hasChanges: Bool {
        guard let savedProfile = userDefaultsKeys.getUserProfile() else {
            return !firstName.isEmpty || !lastName.isEmpty || !userEmail.isEmpty
        }

        return firstName != savedProfile.firstName ||
               lastName != savedProfile.lastName ||
               userEmail != savedProfile.email
    }

    // MARK: - Initialization
    init(userDefaultsKeys: UserDefaultsKeys = UserDefaultsKeys()) {
        self.userDefaultsKeys = userDefaultsKeys
        loadProfile()
        checkNotificationStatus()
    }

    // MARK: - Public Methods
    func loadProfile() {
        if let profile = userDefaultsKeys.getUserProfile() {
            firstName = profile.firstName
            lastName = profile.lastName
            userEmail = profile.email
        }
    }

    func saveProfile() {
        userDefaultsKeys.saveUserProfile(firstName: firstName, lastName: lastName, email: userEmail)
        alertTitle = "Успешно"
        alertMessage = "Данные профиля сохранены"
        showAlert = true
    }

    func toggleNotifications() {
        notificationCenter.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    self?.requestNotificationPermission()
                case .denied:
                    self?.openAppSettings()
                case .authorized, .provisional, .ephemeral:
                    self?.showSettingsAlert = true
                @unknown default:
                    break
                }
            }
        }
    }

    func openNotificationSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }

    // MARK: - Private Methods
    private func checkNotificationStatus() {
        notificationCenter.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.notificationsEnabled = settings.authorizationStatus == .authorized
            }
        }
    }

    private func requestNotificationPermission() {
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.alertTitle = "Ошибка"
                    self?.alertMessage = "Ошибка: \(error.localizedDescription)"
                    self?.showAlert = true
                    return
                }

                if granted {
                    self?.notificationsEnabled = true
                    self?.alertTitle = "Уведомления разрешены"
                    self?.alertMessage = "Теперь вы будете получать уведомления о новинках"
                    self?.showAlert = true

                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    self?.notificationsEnabled = false
                    self?.alertTitle = "Уведомления отключены"
                    self?.alertMessage = "Вы можете включить уведомления в настройках позже"
                    self?.showAlert = true
                }
            }
        }
    }

    private func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl) { [weak self] success in
                if !success {
                    self?.alertTitle = "Ошибка"
                    self?.alertMessage = "Не удалось открыть настройки"
                    self?.showAlert = true
                }
            }
        } else {
            alertTitle = "Ошибка"
            alertMessage = "Не удалось открыть настройки"
            showAlert = true
        }
    }
}
