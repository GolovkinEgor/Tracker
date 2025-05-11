import UIKit
final class CategoryListViewController: UIViewController {
    
    var onCategorySelected: ((Category) -> Void)?

    private let viewModel = CategoryListViewModel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Категории"
        view.backgroundColor = .white

        // Регистрируем класс ячейки с идентификатором "Cell"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate   = self

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
          tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        bindViewModel()
        viewModel.loadCategories()
    }

    private func bindViewModel() {
        viewModel.onCategoriesUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.onError = { [weak self] error in
            let alert = UIAlertController(
                title: "Ошибка",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension CategoryListViewController: UITableViewDataSource {
    func tableView(_ tv: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }

    func tableView(_ tv: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1) dequeue ячейку по идентификатору "Cell"
        let cell = tv.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // 2) получаем модель из VM
        let category = viewModel.category(at: indexPath.row)
        // 3) отображаем её имя
        cell.textLabel?.text = category.name
        // 4) (опционально) можно добавить стрелочку
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension CategoryListViewController: UITableViewDelegate {
    func tableView(_ tv: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cat = viewModel.category(at: indexPath.row)
        onCategorySelected?(cat)
        navigationController?.popViewController(animated: true)
    }
}
