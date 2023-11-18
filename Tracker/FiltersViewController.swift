import UIKit

final class FiltersViewController: UIViewController {
    
    private lazy var filters:[FilterModelData] = [
        FilterModelData(isSelected: selectedFilter == .allTraclers, typeFilter: .allTraclers),
        FilterModelData(isSelected: selectedFilter == .allTrackersToday, typeFilter: .allTrackersToday),
        FilterModelData(isSelected: selectedFilter == .completed, typeFilter: .completed),
        FilterModelData(isSelected: selectedFilter == .incomplete, typeFilter: .incomplete)
    ]
    
    private var selectedFilter: TypesFilters?
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("filters.title", comment: "")
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        label.contentMode = .top
        return label
    }()
    
    private lazy var filtersTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.delegate = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.layer.cornerRadius = 16
        return table
    }()
    
    var completionHandler: ((_ typeFiltr: TypesFilters) -> ())? = nil
    
    init(selectedFilter: TypesFilters) {
        super.init(nibName: nil, bundle: nil)
        self.selectedFilter = selectedFilter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filtersTable.register(FilterCell.self, forCellReuseIdentifier: FilterCell.idCell)
        addSubviews()
        view.backgroundColor = .white
    }

    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(filtersTable)
                
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            filtersTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            filtersTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filtersTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            filtersTable.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = filtersTable.dequeueReusableCell(withIdentifier: FilterCell.idCell, for: indexPath) as? FilterCell
        else {
            return UITableViewCell()
        }
        cell.configure(model: filters[indexPath.row],
                       isLastCell: filters.count - 1 == indexPath.row,
                       isFirstCell: indexPath.row == 0)
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let filtr = filters[indexPath.row].typeFilter
        selectedFilter = filtr
        completionHandler?(filtr)
        dismiss(animated: true)
    }
}
