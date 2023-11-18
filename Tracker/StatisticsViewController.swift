import UIKit

final class StatisticsViewController: UIViewController {
    
    private lazy var capView = {
        let capView = CapView()
        capView.imageCap = UIImage(named: "ImageCapStatistics")
        capView.textCap = NSLocalizedString("textCapStatistics", comment: "")
        capView.translatesAutoresizingMaskIntoConstraints = false
        return capView
    }()
    
    private lazy var statisticsTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.dataSource = self
        table.showsVerticalScrollIndicator = false
        table.separatorStyle = .none
        table.layer.cornerRadius = 16
        return table
    }()
    
    private let viewModel = StatisticsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("statisticsVC.title", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        
        statisticsTable.register(StatisticsCell.self, forCellReuseIdentifier: StatisticsCell.cellID)
        
        addSubviews()
        
        viewModel.$statistics.bind { [weak self] _ in
            guard let self else { return }
            self.statisticsTable.reloadData()
            self.controlVisibilityCapView(isHidden: self.viewModel.statistics.count > 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getStatisrics()
    }
    
    private func addSubviews() {
        view.addSubview(statisticsTable)
        view.addSubview(capView)
        
        NSLayoutConstraint.activate([
            capView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            capView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            statisticsTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 77),
            statisticsTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func controlVisibilityCapView(isHidden: Bool) {
        capView.isHidden = isHidden
    }
    
}

extension StatisticsViewController: UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = statisticsTable.dequeueReusableCell(withIdentifier: StatisticsCell.cellID, for: indexPath) as? StatisticsCell
        else {
            return UITableViewCell()
        }
        let statisticModel = viewModel.statistics[indexPath.row]
        cell.configure(model: StatisticsCellModel(coutn: statisticModel.coutn, name: statisticModel.name))
        return cell
    }

}

