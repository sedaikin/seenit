//
//  SettingsScreenView.swift
//  Seen it
//
//  Created by Rogova Mariya on 05.10.2025.
//

import SwiftUI

struct SettingsScreenView: View {

    // MARK: - Properties
    @StateObject private var viewModel = SettingsScreenViewModel()
    @State private var keyboardHeight: CGFloat = 0

    private var backgroundColor: Color {
        Color(UIColor(named: "background") ?? .systemGroupedBackground)
    }
    private var cardBackgroundColor: Color {
        Color(UIColor(named: "tabbar") ?? .systemBackground)
    }
    private var activeColor: Color {
        Color(UIColor(named: "active") ?? .blue)
    }

    // MARK: - Body
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    profileSection
                    notificationsSection
                    aboutSection
                }
                .padding()
                .padding(.bottom, keyboardHeight)
            }
        }
        .background(backgroundColor.edgesIgnoringSafeArea(.all))
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            setupKeyboardObservers()
        }
        .onDisappear {
            removeKeyboardObservers()
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
        .alert("Отключить уведомления", isPresented: $viewModel.showSettingsAlert) {
            Button("Настройки", role: .none) {
                viewModel.openNotificationSettings()
            }
            Button("Отмена", role: .cancel) { }
        } message: {
            Text("Чтобы отключить уведомления, перейдите в Настройки iPhone → \(Bundle.main.displayName) → Уведомления")
        }
    }
}

// MARK: - View Components
private extension SettingsScreenView {

    // MARK: - Profile Section
    var profileSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Профиль")
                .font(.headline)
                .foregroundColor(.gray)

            VStack(alignment: .leading, spacing: 12) {
                Text("Имя")
                    .foregroundColor(.white)
                    .font(.system(size: 14))

                TextField("", text: $viewModel.firstName, prompt: Text("Введите имя").foregroundColor(.gray))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Фамилия")
                    .foregroundColor(.white)
                    .font(.system(size: 14))

                TextField("", text: $viewModel.lastName, prompt: Text("Введите фамилию").foregroundColor(.gray))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Email")
                    .foregroundColor(.white)
                    .font(.system(size: 14))

                TextField("", text: $viewModel.userEmail, prompt: Text("Введите e-mail").foregroundColor(.gray))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }

            Button(action: {
                viewModel.saveProfile()
            }) {
                Text("Сохранить")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(viewModel.hasChanges ? activeColor : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(!viewModel.hasChanges)
            .padding(.top, 10)
        }
        .padding()
        .background(cardBackgroundColor)
        .cornerRadius(10)
    }

    // MARK: - Notifications Section
    private var notificationsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Уведомления")
                .font(.headline)
                .foregroundColor(.gray)

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Push-уведомления")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))

                    Text(viewModel.notificationsEnabled ?
                         "Уведомления включены" :
                         "Получать уведомления о новинках")
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }

                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 52, height: 32)

                    Toggle("", isOn: Binding(
                        get: { viewModel.notificationsEnabled },
                        set: { _ in
                            viewModel.toggleNotifications()
                        }
                    ))
                    .labelsHidden()
                    .tint(activeColor)
                    .scaleEffect(1.1)
                }
            }
            .padding(.vertical, 10)
        }
        .padding()
        .background(cardBackgroundColor)
        .cornerRadius(10)
    }

    // MARK: - About Section
    var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("О приложении")
                .font(.headline)
                .foregroundColor(.gray)

            HStack {
                Text("Версия")
                    .foregroundColor(.white)
                Spacer()
                Text("1.0.0")
                    .foregroundColor(.gray)
            }

            Button("Политика конфиденциальности") {}
                .foregroundColor(.white)

            Button("Написать отзыв") {}
                .foregroundColor(.white)
        }
        .padding()
        .background(cardBackgroundColor)
        .cornerRadius(10)
    }
}

// MARK: - Keyboard Handling
private extension SettingsScreenView {

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeOut(duration: 0.25)) {
                    keyboardHeight = keyboardFrame.height
                }
            }
        }

        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            withAnimation(.easeOut(duration: 0.25)) {
                keyboardHeight = 0
            }
        }
    }

    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Bundle Extension
extension Bundle {
    var displayName: String {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
               object(forInfoDictionaryKey: "CFBundleName") as? String ??
               "Приложение"
    }
}
