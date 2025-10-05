//
//  BaseViewController.swift
//  Seen it
//
//  Created by Rogova Mariya on 05.10.2025.
//

import UIKit
import SwiftUI

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettingsButton()
    }

    private func setupSettingsButton() {
        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "gearshape"),
            style: .plain,
            target: self,
            action: #selector(openSettings)
        )
        settingsButton.tintColor = UIColor(named: "active")
        navigationItem.rightBarButtonItem = settingsButton
    }

    @objc func openSettings() {
        let settingsView = SettingsScreenView()
        let hostingController = UIHostingController(rootView: settingsView)

        let navController = UINavigationController(rootViewController: hostingController)
        navController.modalPresentationStyle = .fullScreen

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(named: "background")
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        navController.navigationBar.standardAppearance = appearance
        navController.navigationBar.scrollEdgeAppearance = appearance
        navController.navigationBar.tintColor = UIColor(named: "active")

        hostingController.navigationItem.title = "Настройки"
        hostingController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Готово",
            style: .done,
            target: self,
            action: #selector(dismissSettings)
        )

        present(navController, animated: true, completion: nil)
    }

    @objc private func dismissSettings() {
        dismiss(animated: true, completion: nil)
    }
}
