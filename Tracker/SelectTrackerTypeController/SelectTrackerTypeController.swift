//
//  SelectTrackerTypeController.swift
//  Tracker
//
//  Created by Golovkin Egor on 10.04.2025.
//


import UIKit

final class SelectTrackerTypeController: UIViewController {
    
    // MARK: - Private properties
    
    private lazy var habitButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("habit_button", comment: ""), for: .normal)
        
        button.addTarget(
            self,
            action: #selector(didTapHabitButton),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var eventButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("event_button", comment: ""), for: .normal)
        
        button.addTarget(
            self,
            action: #selector(didTapEventButton),
            for: .touchUpInside
        )
        return button
    }()
    
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.text = NSLocalizedString("select_tracker_title", comment: "")
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    // MARK: - Overrides mathods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupСonstraints()
        
        view.backgroundColor = .white
    }
    
    // MARK: - @objc mathods
    
    @objc func didTapHabitButton() {
        openCreateTrackerVC(needSchedule: true)
    }
    
    @objc func didTapEventButton() {
        openCreateTrackerVC(needSchedule: false)
    }
    
    // MARK: - Private mathods
    
    private func setupViews() {
        [habitButton, eventButton, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
    }
    
    private func setupСonstraints(){
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            habitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            habitButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            habitButton.widthAnchor.constraint(equalToConstant: 335),
            
            eventButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.widthAnchor.constraint(equalToConstant: 335),
        ])
    }
    
    private func openCreateTrackerVC(needSchedule: Bool) {
        // 1. Создаём экран для создания трекера
        let createTrackerVC = CreateTrackerController(needSchedule: needSchedule)

        // 2. Находим ваш TabBarController и в нём первый контроллер — TrackersViewController
        if let tabBar = view.window?.rootViewController as? TabBarController,
           let trackersVC = tabBar.viewControllers?.first as? TrackersViewController {
            
            // 3. Назначаем замыкание, чтобы после создания трекера вызвать addTracker(for:)
            createTrackerVC.onCreateTracker = { category in
                trackersVC.addTracker(for: category)
            }
            
            // 4. Оборачиваем в UINavigationController и показываем модально
            let nav = UINavigationController(rootViewController: createTrackerVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }


}
