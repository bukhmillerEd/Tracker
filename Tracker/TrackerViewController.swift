
import UIKit

enum TypeTracker {
    case habit
    case event
}

final class TrackerViewController: UIViewController {
    
    private var typeTracker: TypeTracker
    private var schedule: [Schedule] = []
    var completionHandler: ((_ tracker: Tracker?) -> Void)?
    private var selectedEmoji = ""
    private var selectedColor: UIColor? = nil
    
    let emojis = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    let colors = [
        UIColor(named: "ColorSelection1"),
        UIColor(named: "ColorSelection2"),
        UIColor(named: "ColorSelection3"),
        UIColor(named: "ColorSelection4"),
        UIColor(named: "ColorSelection5"),
        UIColor(named: "ColorSelection6"),
        UIColor(named: "ColorSelection7"),
        UIColor(named: "ColorSelection8"),
        UIColor(named: "ColorSelection9"),
        UIColor(named: "ColorSelection10"),
        UIColor(named: "ColorSelection11"),
        UIColor(named: "ColorSelection12"),
        UIColor(named: "ColorSelection13"),
        UIColor(named: "ColorSelection14"),
        UIColor(named: "ColorSelection15"),
        UIColor(named: "ColorSelection16"),
        UIColor(named: "ColorSelection17"),
        UIColor(named: "ColorSelection18")
    ]
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = typeTracker == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        return label
    }()
    
    private lazy var nameTextField: TextFieldWidthPadding = {
        let field = TextFieldWidthPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 16)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Введите название трекера"
        field.layer.cornerRadius = 16
        field.backgroundColor = UIColor(named: "backgroundField")
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    private lazy var errorLimitSumbolsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Ограничение 38 символов"
        label.font = UIFont(name: "SFPro-Regular", size: 17)
        label.textColor = UIColor(named: "colorTextError")
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var stackName: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var stackButtons: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.backgroundColor = UIColor(named: "backgroundField")
        stack.layer.cornerRadius = 16
        return stack
    }()
    
    private lazy var containerViewCategoryButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        return view
    }()
    
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Категория"
        label.font = UIFont(name: "SFPro-Regular", size: 17)
        label.backgroundColor = UIColor(white: 0, alpha: 0)
        return label
    }()
    
    private lazy var categoryNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Важное"
        label.font = UIFont(name: "SFPro-Regular", size: 17)
        label.textColor = UIColor(named: "ypGray")
        label.backgroundColor = UIColor(white: 0, alpha: 0)
        return label
    }()
    
    private lazy var chevronImageCategory: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Chevron")
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var chevronImageSchedule: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Chevron")
        imageView.contentMode = .center
        return imageView
    }()
    
    private lazy var stackCategoryButtonLabels: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.backgroundColor = UIColor(white: 0, alpha: 0)
        return stack
    }()
    
    private lazy var categoryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"SFPro-Medium", size: 16)
        button.backgroundColor = UIColor(white: 0, alpha: 0)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var containerViewScheduleButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        view.isHidden = typeTracker == .event
        return view
    }()
    
    private lazy var scheduleButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont(name:"SFPro-Medium", size: 16)
        button.backgroundColor = UIColor(white: 0, alpha: 0)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(scheduleButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var scheduleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Расписание"
        label.font = UIFont(name: "SFPro-Regular", size: 17)
        return label
    }()
    
    private lazy var scheduleSelectedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "SFPro-Regular", size: 17)
        label.textColor = UIColor(named: "ypGray")
        return label
    }()
    
    private lazy var stackScheduleButtonLabels: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.backgroundColor = UIColor(white: 0, alpha: 0)
        stack.layer.cornerRadius = 16
        return stack
    }()
    
    private lazy var emojisAndColorsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 5
        layout.itemSize = CGSize(width: 52, height: 52)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.isScrollEnabled = false
        collection.allowsMultipleSelection = true
        return collection
    }()
    
    private lazy var stackBottomButtons: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отменить", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.layer.borderColor = UIColor(named: "ypRed")?.cgColor
        button.setTitleColor(UIColor(named: "ypRed"), for: .normal)
        button.tintColor = .black
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var createButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Создать", for: .normal)
        button.backgroundColor = .gray
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.tintColor = .white
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    init(typeTracker: TypeTracker) {
        self.typeTracker = typeTracker
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
        
        emojisAndColorsCollectionView.delegate = self
        emojisAndColorsCollectionView.dataSource = self
        emojisAndColorsCollectionView.register(EmojiAndColorCollectionViewCell.self, forCellWithReuseIdentifier: EmojiAndColorCollectionViewCell.idCell)
        emojisAndColorsCollectionView.register(HeaderSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSupplementaryView.headerId)
        
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        
        stackName.addArrangedSubview(nameTextField)
        stackName.addArrangedSubview(errorLimitSumbolsLabel)
        contentView.addSubview(stackName)
        
        stackButtons.addArrangedSubview(containerViewCategoryButton)
        stackButtons.addArrangedSubview(containerViewScheduleButton)
        
        containerViewScheduleButton.addSubview(stackScheduleButtonLabels)
        containerViewScheduleButton.addSubview(chevronImageSchedule)
        stackScheduleButtonLabels.addArrangedSubview(scheduleLabel)
        stackScheduleButtonLabels.addArrangedSubview(scheduleSelectedLabel)
        containerViewScheduleButton.addSubview(scheduleButton)
        
        if typeTracker == .habit {
            stackButtons.addSeparators(color: UIColor(named: "ypGray") ?? UIColor(ciColor: .gray), thickness: 1)
        }
        contentView.addSubview(stackButtons)
        
        containerViewCategoryButton.addSubview(stackCategoryButtonLabels)
        containerViewCategoryButton.addSubview(chevronImageCategory)
        stackCategoryButtonLabels.addArrangedSubview(categoryLabel)
        stackCategoryButtonLabels.addArrangedSubview(categoryNameLabel)
        
        containerViewCategoryButton.addSubview(categoryButton)
        
        contentView.addSubview(emojisAndColorsCollectionView)
        
        contentView.addSubview(stackBottomButtons)
        stackBottomButtons.addArrangedSubview(cancelButton)
        stackBottomButtons.addArrangedSubview(createButton)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: typeTracker == .habit ? 850 : 790),
            
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            stackName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackName.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            stackButtons.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackButtons.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackButtons.topAnchor.constraint(equalTo: stackName.bottomAnchor, constant: 24),
            
            containerViewCategoryButton.heightAnchor.constraint(equalToConstant: 75),
            containerViewScheduleButton.heightAnchor.constraint(equalToConstant: 75),
            
            chevronImageCategory.topAnchor.constraint(equalTo: containerViewCategoryButton.topAnchor),
            chevronImageCategory.trailingAnchor.constraint(equalTo: containerViewCategoryButton.trailingAnchor),
            chevronImageCategory.bottomAnchor.constraint(equalTo: containerViewCategoryButton.bottomAnchor),
            chevronImageCategory.widthAnchor.constraint(equalToConstant: 56),
            
            chevronImageSchedule.topAnchor.constraint(equalTo: containerViewScheduleButton.topAnchor),
            chevronImageSchedule.trailingAnchor.constraint(equalTo: containerViewScheduleButton.trailingAnchor),
            chevronImageSchedule.bottomAnchor.constraint(equalTo: containerViewScheduleButton.bottomAnchor),
            chevronImageSchedule.widthAnchor.constraint(equalToConstant: 56),
            
            categoryLabel.heightAnchor.constraint(equalToConstant: 22),
            categoryNameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            scheduleLabel.heightAnchor.constraint(equalToConstant: 22),
            scheduleSelectedLabel.heightAnchor.constraint(equalToConstant: 22),
            
            stackCategoryButtonLabels.leadingAnchor.constraint(equalTo: containerViewCategoryButton.leadingAnchor),
            stackCategoryButtonLabels.topAnchor.constraint(equalTo: containerViewCategoryButton.topAnchor, constant: 15),
            stackCategoryButtonLabels.bottomAnchor.constraint(equalTo: containerViewCategoryButton.bottomAnchor, constant: -14),
            stackCategoryButtonLabels.trailingAnchor.constraint(equalTo: chevronImageCategory.leadingAnchor),
            
            categoryButton.leadingAnchor.constraint(equalTo: containerViewCategoryButton.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: containerViewCategoryButton.trailingAnchor),
            categoryButton.topAnchor.constraint(equalTo: containerViewCategoryButton.topAnchor),
            categoryButton.bottomAnchor.constraint(equalTo: containerViewCategoryButton.bottomAnchor),
            
            stackScheduleButtonLabels.leadingAnchor.constraint(equalTo: containerViewScheduleButton.leadingAnchor),
            stackScheduleButtonLabels.topAnchor.constraint(equalTo: containerViewScheduleButton.topAnchor, constant: 15),
            stackScheduleButtonLabels.bottomAnchor.constraint(equalTo: containerViewScheduleButton.bottomAnchor, constant: -14),
            stackScheduleButtonLabels.trailingAnchor.constraint(equalTo: chevronImageSchedule.leadingAnchor),
            
            scheduleButton.leadingAnchor.constraint(equalTo: containerViewScheduleButton.leadingAnchor),
            scheduleButton.trailingAnchor.constraint(equalTo: containerViewScheduleButton.trailingAnchor),
            scheduleButton.topAnchor.constraint(equalTo: containerViewScheduleButton.topAnchor),
            scheduleButton.bottomAnchor.constraint(equalTo: containerViewScheduleButton.bottomAnchor),
            
            emojisAndColorsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emojisAndColorsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emojisAndColorsCollectionView.topAnchor.constraint(equalTo: stackButtons.bottomAnchor, constant: 16),
            emojisAndColorsCollectionView.heightAnchor.constraint(equalToConstant: 442),
            
            stackBottomButtons.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackBottomButtons.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackBottomButtons.topAnchor.constraint(equalTo: emojisAndColorsCollectionView.bottomAnchor, constant: 16),
            stackBottomButtons.heightAnchor.constraint(equalToConstant: 60),
            
            cancelButton.widthAnchor.constraint(equalTo: createButton.widthAnchor)
        ])
    }
    
    private func checkRequiredFields() {
        let fieldsFilled = (nameTextField.text?.count ?? 0 >= 1)
        && (typeTracker == .habit ? schedule.count > 0 : true) && (selectedColor != nil) && (!selectedEmoji.isEmpty)
        if fieldsFilled {
            createButton.isEnabled = true
            createButton.backgroundColor = .black
        } else {
            createButton.isEnabled = false
            createButton.backgroundColor = .gray
        }
    }
    
    @objc private func categoryButtonTapped() {
        print("categoryButtonTapped")
    }
    
    @objc private func scheduleButtonTapped() {
        let vc = ScheduleViewController(daysSchedule: schedule, delegate: self)
        present(vc, animated: true)
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        let tracker = Tracker(name: nameTextField.text ?? "",
                              color: selectedColor,
                              emoji: selectedEmoji,
                              schedule: schedule)
        dismiss(animated: true)
        completionHandler?(tracker)
    }
}

extension TrackerViewController: UITextFieldDelegate {
    @objc func dismissKeyboard() {
        scrollView.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let textLenght = text.count - range.length + string.count
        errorLimitSumbolsLabel.isHidden = textLenght <= 38
        checkRequiredFields()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        errorLimitSumbolsLabel.isHidden = true
        return true
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        deselectSelectedItemsInSection(indexPath: indexPath, collectionView: collectionView)
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCollectionViewCell
        cell?.selectCell()
        if indexPath.section == 0 {
            selectedEmoji = emojis[indexPath.row]
        } else {
            selectedColor = colors[indexPath.row]
        }
        checkRequiredFields()
    }
    
    private func deselectSelectedItemsInSection(indexPath: IndexPath, collectionView: UICollectionView) {
        collectionView.indexPathsForSelectedItems?.forEach({ selectedIndexPath in
            if selectedIndexPath.section == indexPath.section,
               selectedIndexPath.row != indexPath.row {
                collectionView.deselectItem(at: selectedIndexPath, animated: true)
                let cell = collectionView.cellForItem(at: selectedIndexPath) as? EmojiAndColorCollectionViewCell
                cell?.deselectCell()
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? EmojiAndColorCollectionViewCell
        cell?.deselectCell()
        if indexPath.section == 0 {
            selectedEmoji = ""
        } else {
            selectedColor = nil
        }
        checkRequiredFields()
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiAndColorCollectionViewCell.idCell, for: indexPath) as? EmojiAndColorCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            let model = EmojiAndColorCollectionViewCellModelView(typeCell: .emoji, color: nil, emoji: emojis[indexPath.row])
            cell.configure(modelView: model)
        } else {
            let model = EmojiAndColorCollectionViewCellModelView(typeCell: .color, color: colors[indexPath.row], emoji: "")
            cell.configure(modelView: model)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSupplementaryView.headerId, for: indexPath) as? HeaderSupplementaryView
        else {
            return UICollectionReusableView()
        }
        view.configure(headerText: indexPath.section == 0 ? "Emoji" : "Цвет")
        return view
    }

}

extension TrackerViewController: SchedulebleDelegate {
    func selectedSchedule(daysSchedule: [Schedule]) {
        scheduleSelectedLabel.text = daysSchedule.count == 7 ? "Каждый день" : daysSchedule.map { $0.shortRepresentation() }.joined(separator: ", ")
        schedule = daysSchedule
        checkRequiredFields()
    }
}
