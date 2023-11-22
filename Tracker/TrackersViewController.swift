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
    
    private var filterWeekDay: String = ""
    
    private var dataProvider: DataProvider?
    
    private var analyticsService: AnalyticsServiceProtocol?
    
    private var selectedFilter: TypesFilters = .allTraclers {
        didSet {
            if selectedFilter == .allTrackersToday {
                datePicker.date = Date()
                currentDate = Date()
            }
        }
    }
    
    private lazy var addTrackerButton: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem()
        barButtonItem.image = UIImage(systemName: "plus")
        barButtonItem.action = #selector(addTrackerTapped)
        barButtonItem.tintColor = Colors.viewBackgroundColor
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
        searchController.searchBar.placeholder = NSLocalizedString("search", comment: "")
        searchController.searchBar.setValue(NSLocalizedString("cancel", comment: ""), forKey: "cancelButtonText")
        searchController.delegate = self
        return searchController
    }()
    
    private lazy var capView = {
        let view = CapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var filtersButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"SFPro-Regular", size: 17)
        button.backgroundColor = UIColor(named: "filterButtonColor")
        button.layer.cornerRadius = 16
        button.setTitle(NSLocalizedString("filterButton", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(filtersButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: -  LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.systemBackgroundColor
        
        dataProvider = DataProviderForCoreData(delegate: self)
        
        analyticsService = AnalyticsService()
        
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        trackersCollectionView.register(TrackerViewCell.self, forCellWithReuseIdentifier: TrackerViewCell.cellID)
        trackersCollectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.headerId)
        trackersCollectionView.showsVerticalScrollIndicator = false
        trackersCollectionView.showsHorizontalScrollIndicator = false
        
        navigationItem.title = NSLocalizedString("trackersVC.title", comment: "")
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        
        addSubviews()
        
        currentDate = datePicker.calendar.startOfDay(for: datePicker.date)
        
        getTrackers()
        configureViews(isData: dataProvider?.numberOfSections() ?? 0 > 0,
                       textCap: NSLocalizedString("capViewTextStart", comment: "Text for the cap on the trackers sceen"),
                       imageCap: UIImage(named: "imageCap"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        analyticsService?.report(analyticalDataModel: AnalyticalDataModel(event: .open, screen: .main, item: nil))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        analyticsService?.report(analyticalDataModel: AnalyticalDataModel(event: .close, screen: .main, item: nil))
    }
    
    @objc private func addTrackerTapped() {
        let additingTrackerViewController = AdditingTrackerViewController()
        additingTrackerViewController.delegate = self
        present(additingTrackerViewController, animated: true)
        analyticsService?.report(analyticalDataModel: AnalyticalDataModel(event: .click, screen: .main, item: .addTrack))
    }
    
    @objc private func dateChanged(sender: UIDatePicker) {
        currentDate = datePicker.calendar.startOfDay(for: datePicker.date)
        getTrackers()
        configureViews(isData: dataProvider?.numberOfSections() ?? 0 > 0,
                       textCap: NSLocalizedString("capViewTextAfterSearch", comment: "Text for the cap on the trackers sceen"),
                       imageCap: UIImage(named: "imageCapAfterSearch"))
    }
    
    @objc func filtersButtonTapped() {
        let filtersVC = FiltersViewController(selectedFilter: selectedFilter)
        filtersVC.completionHandler = { [weak self] filter in
            guard let self, self.selectedFilter != filter else { return }
            self.selectedFilter = filter
            self.getTrackers()
            self.configureViews(isData: dataProvider?.numberOfSections() ?? 0 > 0,
                                textCap: NSLocalizedString("capViewTextAfterSearch", comment: "Text for the cap on the trackers sceen"),
                                imageCap: UIImage(named: "imageCapAfterSearch"))
        }
        present(filtersVC, animated: true)
        analyticsService?.report(analyticalDataModel: AnalyticalDataModel(event: .click, screen: .main, item: .filter))
    }
    
    private func addSubviews() {
        navigationController?.navigationBar.topItem?.leftBarButtonItem = addTrackerButton
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        
        view.addSubview(trackersCollectionView)
        view.addSubview(capView)
        view.addSubview(filtersButton)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            trackersCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            capView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            capView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            filtersButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filtersButton.heightAnchor.constraint(equalToConstant: 50),
            filtersButton.widthAnchor.constraint(equalToConstant: 114),
            filtersButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
        ])
    }
    
    private func configureViews(isData: Bool, textCap: String, imageCap: UIImage?) {
        hiddenCapStackView(hide: isData, textCap: textCap, imageCap: imageCap)
        hiddenFiltersButton(hide: !isData)
        addOverscrollForCollection(bottomContentInset: isData ? 60 : 0)
    }
    
    private func hiddenFiltersButton(hide: Bool) {
        filtersButton.isHidden = hide
    }
    
    private func addOverscrollForCollection(bottomContentInset: CGFloat) {
        trackersCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomContentInset, right: 0)
    }
    
    private func hiddenCapStackView(hide: Bool, textCap: String, imageCap: UIImage?) {
        capView.textCap = textCap
        capView.imageCap = imageCap
        capView.isHidden = hide
    }
    
    private func pinTracker(tracker: Tracker, pin: Bool, nameCategory: String) {
        if pin {
            dataProvider?.saveEditedTracker(tracker: tracker, titleTrackerCategory: NSLocalizedString("pinCategoryName", comment: ""))
        } else {
            dataProvider?.removeTrackerFromCategory(withID: tracker.id, from: nameCategory)
        }
    }
    
    private func editTracker(tracker: Tracker, nameCategory: String) {
        let typeTracker: TypeTracker = tracker.schedule.count == 0 ? .event : .habit
        let vc = TrackerViewController(typeTracker: typeTracker,
                                       tracker: tracker,
                                       nameCategory: nameCategory,
                                       countCompletedTracker: dataProvider?.getCountCompletedTrackers(withID: tracker.id))
        vc.completionHandler = { [weak self] tracker, nameCategory in
            guard let self, let tracker, let nameCategory else { return }
            self.dataProvider?.saveEditedTracker(tracker: tracker, titleTrackerCategory: nameCategory)
        }
        present(vc, animated: true)
        analyticsService?.report(analyticalDataModel: AnalyticalDataModel(event: .click, screen: .main, item: .edit))
    }
    
    private func removeTracker(tracker: Tracker) {
        let alertController = UIAlertController(title: NSLocalizedString("alert.confirmDeletionTracker", comment: ""),
                                                message: nil,
                                                preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: NSLocalizedString("delete", comment: ""), style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.dataProvider?.removeTracker(withID: tracker.id)
        }
        alertController.addAction(deleteAction)
        
        let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        analyticsService?.report(analyticalDataModel: AnalyticalDataModel(event: .click, screen: .main, item: .delete))
    }
    
    private func getTrackers() {
        dataProvider?.getTrackers(withFilter: selectedFilter, forWeakDay: filterWeekDay)
        trackersCollectionView.reloadData()
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
        let namesCategories = dataProvider?.getNamesSections() ?? []
        let nameCategory = namesCategories.count - 1 >= indexPath.section ? namesCategories[indexPath.section] : ""
        let model = TrackerCellViewModel(name: tracker.name,
                                         emoji: tracker.emoji,
                                         color: tracker.color,
                                         trackerIsDone: idCompletedTrackers.contains(tracker.id),
                                         doneButtonIsEnabled: resCompare == .orderedSame || resCompare == .orderedDescending,
                                         counter: countComletedTracker ?? 0,
                                         id: tracker.id,
                                         isPin: nameCategory == NSLocalizedString("pinCategoryName", comment: ""))
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
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first,
              let tracker = dataProvider?.getTracker(at: indexPath),
              let nameCategory = dataProvider?.getNamesSections()[safe: indexPath.section]
        else { return nil }
        
        return UIContextMenuConfiguration(actionProvider: { _ in
            let pinAvailable = nameCategory != NSLocalizedString("pinCategoryName", comment: "")
            let nameAction = pinAvailable ? NSLocalizedString("pin", comment: "") : NSLocalizedString("unpin", comment: "")
            let pin = UIAction(title: nameAction) { [weak self] _ in
                guard let self else { return }
                self.pinTracker(tracker: tracker, pin: pinAvailable, nameCategory: nameCategory)
            }
            let editAction = UIAction(title: NSLocalizedString("edit", comment: "")){ [weak self] _ in
                guard let self else { return }
                self.editTracker(tracker: tracker, nameCategory: nameCategory)
            }
            let removeAction = UIAction(title: NSLocalizedString("delete", comment: "")){ [weak self] _ in
                guard let self else { return }
                self.removeTracker(tracker: tracker)
            }
            removeAction.attributes = .destructive
            return UIMenu(title: "", image: nil, children: [pin, editAction, removeAction])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        contextMenuConfiguration configuration: UIContextMenuConfiguration,
                        highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard let cell = collectionView.cellForItem(at: indexPath) as? TrackerViewCell else { return nil }
        return UITargetedPreview(view: cell.getViewForPreview())
    }
    
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let filterText = searchController.searchBar.searchTextField.text?.lowercased()
        else { return }
        dataProvider?.filterTrackers(byName: filterText, forWeakDay: filterWeekDay)
        trackersCollectionView.reloadData()
        configureViews(isData: dataProvider?.getCountTrackers() ?? 0 > 0,
                       textCap: NSLocalizedString("capViewTextAfterSearch", comment: ""),
                       imageCap: UIImage(named: "imageCapAfterSearch"))
    }
}

extension TrackersViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        getTrackers()
        configureViews(isData: dataProvider?.getCountTrackers() ?? 0 > 0,
                       textCap: NSLocalizedString("capViewTextAfterSearch", comment: ""),
                       imageCap: UIImage(named: "imageCapAfterSearch"))
    }
}

extension TrackersViewController: ExecutionManagerDelegate {
    func executionСontrol(id: UUID) {
        let idCompletedTrackers = dataProvider?.getIDCompletedTrackers(in: currentDate) ?? Set<UUID>()
        idCompletedTrackers.contains(id) ? removeExecutionTracker(id: id) : addExecutionTracker(id: id)
        analyticsService?.report(analyticalDataModel: AnalyticalDataModel(event: .click, screen: .main, item: .track))
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
        configureViews(isData: dataProvider?.numberOfSections() ?? 0 > 0,
                       textCap: NSLocalizedString("capViewTextAfterSearch", comment: ""),
                       imageCap: UIImage(named: "imageCapAfterSearch"))
    }
}
