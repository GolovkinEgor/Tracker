//
//  FilterViewController.swift
//  Tracker
//
//  Created by Golovkin Egor on 19.05.2025.
//

import UIKit

enum TrackerFilter: Int, CaseIterable {
  case all, today, completed, incomplete

  var title: String {
    switch self {
    case .all: return "Все трекеры"
    case .today: return "Трекеры на сегодня"
    case .completed: return "Завершённые"
    case .incomplete: return "Незавершённые"
    }
  }
}

protocol FilterViewControllerDelegate: AnyObject {
  func filterViewController(_ vc: UIViewController, didSelect filter: TrackerFilter)
}

final class FilterViewController: UITableViewController {
  weak var delegate: FilterViewControllerDelegate?
  var selectedFilter: TrackerFilter = .all

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    title = "Фильтры"
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .close,
      target: self,
      action: #selector(dismissSelf)
    )
  }

  @objc private func dismissSelf() {
    dismiss(animated: true)
  }

  override func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
    TrackerFilter.allCases.count
  }
  override func tableView(_ tv: UITableView, cellForRowAt ip: IndexPath) -> UITableViewCell {
    let cell = tv.dequeueReusableCell(withIdentifier: "cell", for: ip)
    let filter = TrackerFilter(rawValue: ip.row)!
    cell.textLabel?.text = filter.title
    cell.accessoryType = (filter == selectedFilter) ? .checkmark : .none
    return cell
  }
  override func tableView(_ tv: UITableView, didSelectRowAt ip: IndexPath) {
    let filter = TrackerFilter(rawValue: ip.row)!
    selectedFilter = filter
    delegate?.filterViewController(self, didSelect: filter)
  }
}
