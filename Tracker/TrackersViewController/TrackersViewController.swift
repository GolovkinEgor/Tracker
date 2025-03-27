//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Golovkin Egor on 27.03.2025.
//
import UIKit

final class TrackersViewController: UIViewController {
    // MARK: - Properties
    //  Модель данных (пока пустая)
    private var trackers: [Tracker] = []
    // MARK: - UI Elements
    private lazy var placeholderView: UIView = {
        let view = UIView()
        view.isHidden = true
        
        let image = UIImage(named: "noTrackersImage")
        let imageView = UIImageView(image: image)
        
        
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        
        view.addSubview(imageView)
        view.addSubview(label)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -20),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updatePlaceholderVisibility()
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Трекеры"
        
        // Кнопка "+" в navigationBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addButtonTapped)
        )
        
        // Добавляем заглушку
        view.addSubview(placeholderView)
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            placeholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updatePlaceholderVisibility() {
        placeholderView.isHidden = !trackers.isEmpty
    }
    
    @objc private func addButtonTapped() {
        // TODO: Реализовать открытие экрана создания трекера
        print("Кнопка '+' нажата")
    }
}
