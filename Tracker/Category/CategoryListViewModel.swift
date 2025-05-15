//
//  CategoryListViewModel.swift
//  Tracker
//
//  Created by Golovkin Egor on 11.05.2025.
//

import Foundation


final class CategoryListViewModel {
    private let service = CategoryService()
    private(set) var categories: [Category] = []

    /// Вызывается сразу после обновления массива `categories`
    var onCategoriesUpdate: (() -> Void)?
    /// При ошибке с загрузкой
    var onError: ((Error) -> Void)?

    func loadCategories() {
        service.fetchCategories { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cats):
                    self?.categories = cats
                    self?.onCategoriesUpdate?()
                case .failure(let error):
                    self?.onError?(error)
                }
            }
        }
    }

    func numberOfRows() -> Int { categories.count }
    func category(at idx: Int) -> Category { categories[idx] }
}
