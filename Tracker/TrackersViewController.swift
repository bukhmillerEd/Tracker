import UIKit

protocol TrackersViewControllerDelegate: AnyObject {
    func updateTrackersCollections(didUpdate update: TrackersUpdate)
}

final class TrackersViewController: UIViewController {
    
    private var currentDate: Date = Date(){
        didSet {
            let calendar = Calendar.current
            filterWeekDay = String(calendar.component(.weekday, from: currentDate))
        }
    }
    
    private var filterWeekDay: String = "" {
        didSet {
            dataProvider?.filterTrackers(byWeekDay: filterWeekDay)
        }
    }
    
    private var dataProvider: DataProvider?

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
        datePicker.timeZone = TimeZone.current
        return datePicker
    }()
    
    lazy var trackersCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.alwaysBounceVertical = true
        return collectionView
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
        view.backgroundColor = .white
        
        dataProvider = DataProviderForCoreData(delegate: self)
        
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
        
        currentDate = datePicker.calendar.startOfDay(for: datePicker.date)
        
        hiddenCapStackView(hide: dataProvider?.numberOfSections() ?? 0 > 0)
    }
    
    @objc private func addTrackerTapped() {
        let additingTrackerViewController = AdditingTrackerViewController()
        additingTrackerViewController.delegate = self
        present(additingTrackerViewController, animated: true)
    }
    
    @objc private func dateChanged(sender: UIDatePicker) {
        currentDate = datePicker.calendar.startOfDay(for: datePicker.date)
        trackersCollectionView.reloadData()
        hiddenCapStackView(hide: dataProvider?.numberOfSections() ?? 0 > 0)
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
    
    private func hiddenCapStackView(hide: Bool) {
        capStackView.isHidden = hide
    }
    
}

extension TrackersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataProvider?.numberOfSections() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataProvider?.numberOfRowsInSection(section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerViewCell.cellID,
                                                            for: indexPath) as? TrackerViewCell,
              let tracker = dataProvider?.getTracker(at: indexPath)
        else {
            return UICollectionViewCell()
        }

        let resCompare = Calendar.current.compare(Date(), to: currentDate, toGranularity: .day)
        let idCompletedTrackers = dataProvider?.getIDCompletedTrackers(in: currentDate) ?? Set<UUID>()
        let countComletedTracker = dataProvider?.getCountCompletedTrackers(withID: tracker.id)
        let model = TrackerCellViewModel(name: tracker.name,
                                         emoji: tracker.emoji,
                                         color: tracker.color,
                                         trackerIsDone: idCompletedTrackers.contains(tracker.id),
                                         doneButtonIsEnabled: resCompare == .orderedSame || resCompare == .orderedDescending,
                                         counter: countComletedTracker ?? 0,
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
        let names = dataProvider?.getNamesSections() ?? []
        let name = names.count - 1 >= indexPath.section ? names[indexPath.section] : ""
        view.configure(headerText: name)
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
        guard let filterText = searchController.searchBar.searchTextField.text?.lowercased(),
           filterText.count > 0
        else { return }
        dataProvider?.filterTrackers(byName: filterText)
        trackersCollectionView.reloadData()
    }
}

extension TrackersViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        dataProvider?.filterTrackers(byWeekDay: filterWeekDay)
        trackersCollectionView.reloadData()
    }
}

extension TrackersViewController: ExecutionManagerDelegate {
    func executionСontrol(id: UUID) {
        let idCompletedTrackers = dataProvider?.getIDCompletedTrackers(in: currentDate) ?? Set<UUID>()
        idCompletedTrackers.contains(id) ? removeExecutionTracker(id: id) : addExecutionTracker(id: id)
    }
    
    private func addExecutionTracker(id: UUID) {
        dataProvider?.addRecordTracker(TrackerRecord(id: id, date: currentDate))
    }
    
    private func removeExecutionTracker(id: UUID) {
        dataProvider?.removeRecordTracker(TrackerRecord(id: id, date: currentDate))
    }
}

extension TrackersViewController: CreatableAndEditableTrackerDelegate {
    func createTracker(tracker: Tracker, inCategoryWithTitle titleCategory: String) {
        dataProvider?.addNewTracker(tracker: tracker, inCategoryWithTitle: titleCategory)
    }
}

extension TrackersViewController: TrackersViewControllerDelegate {
    func updateTrackersCollections(didUpdate update: TrackersUpdate) {
        trackersCollectionView.reloadData()
        hiddenCapStackView(hide: dataProvider?.numberOfSections() ?? 0 > 0)
    }
}
