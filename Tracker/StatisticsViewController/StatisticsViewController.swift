//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Golovkin Egor on 27.03.2025.
//

import UIKit


final class StatisticsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Статистика"
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Здесь будет статистика"
        placeholderLabel.textAlignment = .center
        placeholderLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        view.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
