import UIKit

final class TrackersViewController: UIViewController {
    
    private var visibleCategories: [TrackerCategory] = []
    private var completedTrackers: [TrackerRecord] = []
    private var idCompletedTrackers = Set<UUID>()
    private var currentDate: Date = Date()
    private var categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Уборка",
            trackers: [
                Tracker(
                    name: "Помыть посуду",
                    color: .blue,
                    emoji: "❤️",
                    schedule: [.monday, .saturday, .friday]),
                Tracker(
                    name: "Постирать, высушить и Погладить одежду",
                    color: .brown,
                    emoji: "🌺",
                    schedule: [.wednesday])
            ]),
        TrackerCategory(
            title: "Сделать уроки",
            trackers: [
                Tracker(
                    name: "Математика",
                    color: .brown,
                    emoji: "🙂",
                    schedule: [])
            ]),
        TrackerCategory(
            title: "Уборка2",
            trackers: [
                Tracker(
                    name: "Помыть посуду2",
                    color: .blue,
                    emoji: "❤️",
                    schedule: [.saturday]),
                Tracker(
                    name: "Постирать, высушить и Погладить одежду2",
                    color: .green,
                    emoji: "🌺",
                    schedule: [.saturday])
            ]),
        TrackerCategory(
            title: "Уборка3",
            trackers: [
                Tracker(
                    name: "Помыть посуду3",
                    color: .blue,
                    emoji: "❤️",
                    schedule: [.saturday, .friday]),
                Tracker(
                    name: "Постирать, высушить и Погладить одежду3",
                    color: .green,
                    emoji: "🌺",
                    schedule: [.saturday])
            ])
    ]
    
    private lazy var addTrackerButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "plus")
        barButtonItem.action = #selector(addTrackerTapped)
        barButtonItem.tintColor = .black
        barButtonItem.target = self
        return barButtonItem
    }()
    
    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar = Calendar(identifier: .gregorian)
        datePicker.calendar.firstWeekday = 2
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        return datePicker
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let colView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        colView.translatesAutoresizingMaskIntoConstraints = false
        return colView
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        searchController.delegate = self
        return searchController
    }()
    
    private lazy var capStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var capImageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.image = UIImage(named: "imageCup")
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var capText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFPro-Medium", size: 12)
        label.text = "Что будем отслеживать?"
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        visibleCategories = categories
        capStackView.isHidden = !visibleCategories.isEmpty
        
        view.backgroundColor = .white
        
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        trackersCollectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: TrackerViewCell.cellID)
        trackersCollectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.headerId)
        trackersCollectionView.showsVerticalScrollIndicator = false
        trackersCollectionView.showsHorizontalScrollIndicator = false
        
        navigationItem.title = "Трекеры"
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        
        addSubviews()
        
        filterDataByDate()
    }
    
    @objc private func dateButtonTapped() {
        filterDataByDate()
    }
    
    @objc private func addTrackerTapped() {
        let additingTrackerViewController = AdditingTrackerViewController()
        additingTrackerViewController.delegate = self
        present(additingTrackerViewController, animated: true)
    }
    
    @objc private func dateChanged(sender: UIDatePicker) {
        currentDate = datePicker.date
        filterDataByDate()
    }
    
    private func filterDataByDate() {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: currentDate)
        filterData { tracker in
            tracker.schedule.isEmpty ||
            tracker.schedule.contains { weekDay in
                weekDay.rawValue == filterWeekDay
            }
        }
    }
    
    private func filterData(filteringСondition:(Tracker)->(Bool)) {
        visibleCategories = categories.map({ trackerCategory in
            TrackerCategory(title: trackerCategory.title,
                            trackers: trackerCategory.trackers.filter({ tracket in
                filteringСondition(tracket)
            }))
        }).filter({ category in
            category.trackers.count > 0
        })
        trackersCollectionView.reloadData()
        capStackView.isHidden = !visibleCategories.isEmpty
    }
    
    private func applyFilters() {
        guard let filterText = searchController.searchBar.searchTextField.text?.lowercased(),
              filterText.count > 0
        else {
            filterDataByDate()
            return
        }
        filterData { tracker in
            tracker.name.lowercased().contains(filterText)
        }
    }
    
    private func addSubviews() {
        navigationController?.navigationBar.topItem?.leftBarButtonItem = addTrackerButton
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        capStackView.addArrangedSubview(capImageView)
        capStackView.addArrangedSubview(capText)
        
        view.addSubview(trackersCollectionView)
        view.addSubview(capStackView)

        applyConstraints()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            capStackView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            capStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerViewCell.cellID, for: indexPath) as? TrackerViewCell
        else {
            return UICollectionViewCell()
        }
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.row]

        let resCompare = Calendar.current.compare(Date(), to: currentDate, toGranularity: .day)
                                            
        let model = TrackerCellViewModel(name: tracker.name,
                                         emoji: tracker.emoji,
                                         color: tracker.color,
                                         trackerIsDone: idCompletedTrackers.contains(tracker.id),
                                         doneButtonIsEnabled: resCompare == .orderedSame || resCompare == .orderedDescending,
                                         counter: idCompletedTrackers.contains(tracker.id) ? 1 : 0,
                                         id: tracker.id)
        cell.configure(model: model)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.headerId, for: indexPath) as? HeaderSupplementaryView
        else {
            return UICollectionReusableView()
        }
        view.configure(headerText: visibleCategories[indexPath.section].title)
        return view
    }
    
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 9) / 2, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView,
                                             viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                             at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width,
                                                         height: UIView.layoutFittingExpandedSize.height),
                                                  withHorizontalFittingPriority: .required,
                                                  verticalFittingPriority: .fittingSizeLevel)
    }
    
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        applyFilters()
    }
}

extension TrackersViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        filterDataByDate()
    }
}

extension TrackersViewController: ExecutionManagerDelegate {
    func executionСontrol(id: UUID) {
        if idCompletedTrackers.contains(id) {
            removeExecutionTracker(id: id)
        } else {
            addExecutionTracker(id: id)
        }
    }
    
    private func addExecutionTracker(id: UUID) {
        let recordTracker = TrackerRecord(id: id, date: currentDate)
        completedTrackers.append(recordTracker)
        idCompletedTrackers.insert(id)
    }
    
    private func removeExecutionTracker(id: UUID) {
        completedTrackers.removeAll { $0.id == id && $0.date == currentDate}
        idCompletedTrackers.remove(id)
    }
}

extension TrackersViewController: CreatableAndEditableTrackerDelegate {
    func createTracker(tracker: Tracker) {
        let section = 0
        let oldCount = visibleCategories[section].trackers.count
        categories[section].trackers.append(tracker)
        applyFilters()
        let newCount = visibleCategories[section].trackers.count
    
        trackersCollectionView.performBatchUpdates {
            let indexPaths = (oldCount..<newCount).map { i in
                IndexPath(row: i, section: section)
            }
            trackersCollectionView.insertItems(at: indexPaths)
        }
    }
}

