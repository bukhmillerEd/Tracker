import UIKit

final class CategoriesListViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.contentMode = .top
        return label
    }()
    
    private lazy var categoriesTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.layer.cornerRadius = 16
        return table
    }()
    
    private lazy var addCategoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont(name:"SFPro-Medium", size: 16)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addCategoryTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var capView = {
        let view = CapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.capText.text = "Привычки и события можно \n объединить по смыслу"
        return view
    }()
    
    var completionHandler: ((String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoriesTable.register(CategoryListCell.self, forCellReuseIdentifier: CategoryListCell.idCell)
        addSubviews()
        manageHiddenCapView()
        
        view.backgroundColor = .white
        viewModel.$categories.bind { [weak self] _ in
            guard let self else { return }
            self.categoriesTable.reloadData()
        }
    }
    
    private let viewModel = CategoriesListViewModel()
    private var categoriesTableHeightConstraint: NSLayoutConstraint!

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(addCategoryButton)
        view.addSubview(categoriesTable)
        
        let heightCategoriesTable = CGFloat(viewModel.categories.count) * CategoryListCell.heightCell
        categoriesTableHeightConstraint = categoriesTable.heightAnchor.constraint(equalToConstant: heightCategoriesTable)
                
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            categoriesTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            categoriesTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoriesTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoriesTableHeightConstraint,
            
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addCategoryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        if viewModel.categories.isEmpty {
            view.addSubview(capView)
            NSLayoutConstraint.activate([
                capView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                capView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
                capView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                capView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -8),
            ])
        }
    }
    
    private func recalculateTableHeight() {
        let heightCategoriesTable = CGFloat(viewModel.categories.count) * CategoryListCell.heightCell
        categoriesTableHeightConstraint.constant = heightCategoriesTable
        categoriesTable.layoutIfNeeded()
    }
    
    private func confirmDeletion(nameCategory: String) {
        let alertController = UIAlertController(title: "Эта категория точно не нужна?",
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.viewModel.deleteCategory(withName: nameCategory)
            self.categoriesTable.reloadData()
            self.manageHiddenCapView()
            self.recalculateTableHeight()
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
    
        present(alertController, animated: true, completion: nil)
    }
    
    private func presentVCCategory(typeOperation: TypeOperation) {
        let newCategoryVC = CategoryViewController(typeOperation: typeOperation) { [weak self] in
            guard let self else { return }
            self.viewModel.getNameCategories()
            self.manageHiddenCapView()
            self.recalculateTableHeight()
        }
        present(newCategoryVC, animated: true)
    }
    
    private func manageHiddenCapView() {
        capView.isHidden = !viewModel.categories.isEmpty
    }
    
    @objc private func addCategoryTapped() {
        presentVCCategory(typeOperation: .newCategory)
    }
    
}

extension CategoriesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = categoriesTable.dequeueReusableCell(withIdentifier: CategoryListCell.idCell, for: indexPath) as? CategoryListCell
        else {
            return UITableViewCell()
        }
        cell.configure(model: viewModel.categories[indexPath.row],
                       isLastCell: viewModel.categories.count - 1 == indexPath.row,
                       isFirstCell: indexPath.row == 0)
        return cell
    }
}

extension CategoriesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let index = indexPath.row
        let id = "\(index)" as NSString
        let nameCategory = viewModel.categories[index].name
        
        return UIContextMenuConfiguration(identifier: id, previewProvider: nil) {_ in
            let editAction = UIAction(title: "Редактировать"){ [weak self] _ in
                guard let self else { return }
                self.presentVCCategory(typeOperation: .editingCategory(nameCategory: nameCategory))
            }
            let removeAction = UIAction(title: "Удалить"){ [weak self] _ in
                guard let self else { return }
                self.confirmDeletion(nameCategory: nameCategory)
            }
            return UIMenu(title: "", image: nil, children: [editAction, removeAction])
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nameSelectedCategory = viewModel.categories[indexPath.row].name
        viewModel.didSelectedCategory(withName: nameSelectedCategory)
        completionHandler?(nameSelectedCategory)
        dismiss(animated: true)
    }

}
