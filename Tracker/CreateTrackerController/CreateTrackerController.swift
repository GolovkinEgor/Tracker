//
//  CreateTrackerController.swift
//  Tracker
//
//  Created by Golovkin Egor on 10.04.2025.
//
import UIKit

final class CreateTrackerController: UIViewController {
    
    var onCreateTracker: ((TrackerCategory) -> Void)?

    // MARK: - Private properties
    
    private lazy var titleLabel: UILabel = {
        var label = UILabel()
        label.text = needSchedule ? NSLocalizedString("create_habit_title", comment: "Заголовок: новая привычка"): NSLocalizedString("create_event_title", comment: "Заголовок: событие")
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private let emojiLabel: UILabel = {
        var label = UILabel()
        label.text = "Emoji"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let colorLabel: UILabel = {
        var label = UILabel()
        label.text = "Цвет"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 19)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let limitLabel: UILabel = {
        var label = UILabel()
        label.text = "Органичение 38 символов"
        label.textColor = .red
        label.font = .systemFont(ofSize: 17)
        label.isHidden = true
        return label
    }()
    
    private lazy var nameNewTracker: UITextField = {
        var textField = UITextField()
        textField.placeholder = NSLocalizedString("name_placeholder", comment: "")
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .none
        textField.layer.cornerRadius = 16
        textField.backgroundColor = .customGrayBackground
        textField.clearButtonMode = .whileEditing
        return textField
    }()
    
    private lazy var cancelButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .white
        button.tintColor = .red
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
        button.setTitle(NSLocalizedString("cancel_button", comment: ""), for: .normal)
        button.addTarget(
            self,
            action: #selector(didTapCancelButton),
            for: .touchUpInside
        )
        return button
    }()
    
    private lazy var createButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .customGray
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.layer.borderColor = UIColor.customGray.cgColor
        button.layer.borderWidth = 1
        button.setTitle(NSLocalizedString("create_button", comment: ""), for: .normal)
        button.isEnabled = false
        button.addTarget(
            self,
            action: #selector(didTapCreateButton),
            for: .touchUpInside
        )
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let tableView = UITableView()
    private var options = [NSLocalizedString("option_category", comment: "Опция «Категория»")]
    
    private let emojis: [String] = ["🙂","😻","🌺","🐶","❤️","😱",
                                    "😇","😡","🥶","🤔","🙌","🍔",
                                    "🥦","🏓","🥇","🎸","🏝","😪"]
    
    private let colors: [UIColor] = [.trackerColor01, .trackerColor02, .trackerColor03, .trackerColor04, .trackerColor05, .trackerColor06, .trackerColor07, .trackerColor08, .trackerColor09, .trackerColor10, .trackerColor11, .trackerColor12, .trackerColor13, .trackerColor14, .trackerColor15, .trackerColor16, .trackerColor17, .trackerColor18]
    
    private var selectedEmojiIndexPath: IndexPath?
    private var selectedColorIndexPath: IndexPath?
    
    private lazy var emojisCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: "EmojiCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private lazy var colorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = true
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    
    private var needSchedule: Bool = false
    private var nameIsEmpty: Bool = true
    
    private var selectedCategory: String?
    private var selectedEmoji: String = ""
    private var selectedColor: UIColor = .clear
    private var selectedDays: [String] = []
    
    private var tableViewTopConstraint: NSLayoutConstraint?
    weak var createTrackerDelegate: CreateTrackerProtocol?
    
    // MARK: - Overrides methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupСonstraints()
        setupTableView()
        view.backgroundColor = .white
        nameNewTracker.delegate = self
        checkFilling()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emojisCollectionView.layoutIfNeeded()
        let height = emojisCollectionView.contentSize.height
        emojisCollectionView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        colorsCollectionView.layoutIfNeeded()
        let heightcolorsCollectionView = colorsCollectionView.contentSize.height
        colorsCollectionView.heightAnchor.constraint(equalToConstant: heightcolorsCollectionView).isActive = true
        
        contentView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: contentView.bounds.width, height: contentView.bounds.height + 60)
    }
    
    init(needSchedule: Bool) {
        super.init(nibName: nil, bundle: nil)
        if needSchedule {
            self.needSchedule = true
            options.append("Расписание")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - @objc methods
    
    @objc func didTapCancelButton() {
        createTrackerDelegate?.cancelCreateTracker()
    }
    
    @objc func didTapCreateButton() {
        
        let newCategory = createTracker()
        
        // 2. Передаём результат наружу через замыкание
        onCreateTracker?(newCategory)
        
        // 3. Закрываем экран
        dismiss(animated: true, completion: nil)
    }

    
    @objc func didTapCategoryButton() {
        checkFilling()
    }
    
    // MARK: - Private methods
    
    private func setupTableView() {
        
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 75
        tableView.separatorStyle = .none
    }
    
    private func checkFilling() {
        var fillingIsCorrect = false
        let nameIsFilled = !(nameNewTracker.text?.isEmpty ?? true)
        let categoryIsFilled = selectedCategory != ""
        let scheduleIsFilled = selectedDays.count > 0
        let emojiIsFilled = selectedEmoji != ""
        let colorIsFilled = selectedColor != .clear
        
        if needSchedule {
            fillingIsCorrect = !nameIsEmpty && nameIsFilled && categoryIsFilled && emojiIsFilled && colorIsFilled && scheduleIsFilled
        } else {
            fillingIsCorrect = !nameIsEmpty && nameIsFilled && categoryIsFilled && emojiIsFilled && colorIsFilled
        }
        if fillingIsCorrect {
            createButton.isEnabled = true
            createButton.backgroundColor = .customBlack
            createButton.layer.borderColor = UIColor.customBlack.cgColor
        } else {
            createButton.isEnabled = false
        }
    }
    
    private func setupViews() {
        [titleLabel, nameNewTracker, tableView, limitLabel, emojisCollectionView, colorsCollectionView, emojiLabel, colorLabel, stackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameNewTracker)
        contentView.addSubview(tableView)
        contentView.addSubview(limitLabel)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(colorLabel)
        contentView.addSubview(emojisCollectionView)
        contentView.addSubview(colorsCollectionView)
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(createButton)
    }
    
    private func setupСonstraints(){
        
        let tableHeight = CGFloat(75 * options.count)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 32),
            
            nameNewTracker.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameNewTracker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameNewTracker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameNewTracker.heightAnchor.constraint(equalToConstant: 75),
            
            limitLabel.topAnchor.constraint(equalTo: nameNewTracker.bottomAnchor, constant: 8),
            limitLabel.centerXAnchor.constraint(equalTo: nameNewTracker.centerXAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: tableHeight),
            
            emojiLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 28),
            emojiLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            emojiLabel.heightAnchor.constraint(equalToConstant: 18),
            
            emojisCollectionView.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: 12),
            emojisCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojisCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            colorLabel.topAnchor.constraint(equalTo: emojisCollectionView.bottomAnchor, constant: 16),
            colorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            colorLabel.heightAnchor.constraint(equalToConstant: 18),
            
            colorsCollectionView.topAnchor.constraint(equalTo: colorLabel.bottomAnchor, constant: 12),
            colorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            colorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stackView.topAnchor.constraint(equalTo: colorsCollectionView.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        ])
        
        tableViewTopConstraint = tableView.topAnchor.constraint(equalTo: nameNewTracker.bottomAnchor, constant: 24)
        tableViewTopConstraint?.isActive = true
    }
    
    private func createTracker() -> TrackerCategory {
        // 1. Собираем расписание
        var days: [ScheduleItems] = []
        if !selectedDays.isEmpty {
            days = ScheduleItems.allCases.compactMap { item in
                self.selectedDays.contains(item.rawValue) ? item : nil
            }
        }

        // 2. Проверяем, что пользователь выбрал категорию
        //    Если нет — показываем алерт и подставляем дефолт
        let categoryName: String
        if let sel = selectedCategory, !sel.isEmpty {
            categoryName = sel
        } else {
            let alert = UIAlertController(
                title: "Ошибка",
                message: "Пожалуйста, выберите категорию",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            categoryName = "Без категории"
        }

        // 3. Создаём сам Tracker
        let tracker = Tracker(
            name: nameNewTracker.text ?? "Новый трекер",
            emoji: selectedEmoji,
            // если дней нет — передаём nil
            schedule: days.isEmpty ? nil : days,
            color: selectedColor,
            createdDate: Date()
        )

        // 4. Оборачиваем его в категорию и возвращаем
        return TrackerCategory(
            name: categoryName,
            trackers: [tracker]
        )
    }

}

// MARK: - UITableViewDataSource

extension CreateTrackerController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell
        else {
            return UITableViewCell()
        }
        cell.customLabel.text = options[indexPath.row]
        cell.customImageView.image = UIImage(named: "chevron" )
        cell.customImageView.tintColor = .systemGray
        
        if options[indexPath.row] == NSLocalizedString("option_category", comment: "") {
            cell.detailLabel.text = selectedCategory
        } else {
            if selectedDays.count == 7 {
                cell.detailLabel.text = NSLocalizedString("every_day", comment: "")
            } else {
                let shortDays = selectedDays.compactMap { shortDayNames[$0] }.joined(separator: ", ")
                cell.detailLabel.text = shortDays
            }
        }
        cell.backgroundColor = .customGrayBackground
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 16
        
        // закругление ячеек
        if options.count == 1 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.hideSeparator(true)
        } else if indexPath.row == 0 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else if indexPath.row == options.count - 1 {
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.hideSeparator(true)
        }
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: - UITableViewDelegate

extension CreateTrackerController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = options[indexPath.row]
        if option == "Категория" {
            let vc = CategoryListViewController()
            vc.onCategorySelected = { [weak self] cat in
                self?.selectedCategory = cat.name
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        else if options[indexPath.row] == "Расписание" {
            let scheduleVC = ScheduleViewController(data: selectedDays)
            scheduleVC.selectScheduleDelegate = self
            present(scheduleVC, animated: true, completion: nil)
        }
    }
}

// MARK: - UITextFieldDelegate

extension CreateTrackerController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        let limitNotReached = newLength <= 38
        showLimitLabel(show: !limitNotReached)
        
        let newText = (text as NSString).replacingCharacters(in: range, with: string)
        nameIsEmpty = newText.isEmpty
        
        checkFilling()
        return limitNotReached
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        nameIsEmpty = true
        checkFilling()
        return true
    }
    
    func showLimitLabel(show: Bool) {
        if show {
            limitLabel.isHidden = false
            tableViewTopConstraint?.constant = 62
        } else {
            limitLabel.isHidden = true
            tableViewTopConstraint?.constant = 24
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkFilling()
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - ScheduleViewControllerDelegate

extension CreateTrackerController: ScheduleViewControllerDelegate {
    func didSendSchedule(_ selectedDays: [String]) {
        self.selectedDays = selectedDays
        tableView.reloadData()
        checkFilling()
    }
}

// MARK: - UICollectionViewDataSource

extension CreateTrackerController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView == emojisCollectionView ? emojis.count : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case emojisCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmojiCell", for: indexPath) as? EmojiCell
            else { return UICollectionViewCell() }
            cell.emojiLabel.text = emojis[indexPath.item]
            if indexPath == selectedEmojiIndexPath {
                cell.backgroundView?.backgroundColor = .customGraySelecledEmoji
                cell.backgroundView?.layer.cornerRadius = 16
            } else {
                cell.backgroundView?.backgroundColor = .clear
                cell.backgroundView?.layer.cornerRadius = 0
            }
            return cell
        case colorsCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as? ColorCell
            else { return UICollectionViewCell() }
            cell.colorView.backgroundColor = colors[indexPath.item]
            if indexPath == selectedColorIndexPath {
                cell.layer.borderColor = colors[indexPath.item].withAlphaComponent(0.3).cgColor
                cell.layer.borderWidth = 3
                cell.layer.masksToBounds = true
                cell.layer.cornerRadius = 8
            } else {
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.layer.borderWidth = 0
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CreateTrackerController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let spacing: CGFloat = 5
        let availableWidth = collectionView.bounds.width - (5 * spacing)
        let width = availableWidth / 6
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojisCollectionView {
            selectedEmojiIndexPath = indexPath
            selectedEmoji = emojis[indexPath.item]
        } else {
            selectedColorIndexPath = indexPath
            selectedColor = colors[indexPath.item]
        }
        collectionView.reloadData()
        checkFilling()
    }
}
