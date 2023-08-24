
import UIKit

enum TypeTracker {
    case habit
    case event
}

final class TrackerViewController: UIViewController {
    
    private var typeTracker: TypeTracker
    
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
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = typeTracker == .habit ? "Новая привычка" : "Новое нерегулярное событие"
        lbl.font = UIFont(name: "SFPro-Medium", size: 16)
        return lbl
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
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Ограничение 38 символов"
        lbl.font = UIFont(name: "SFPro-Regular", size: 17)
        lbl.textColor = UIColor(named: "colorTextError")
        lbl.textAlignment = .center
        lbl.isHidden = true
        return lbl
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
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Категория"
        lbl.font = UIFont(name: "SFPro-Regular", size: 17)
        lbl.backgroundColor = UIColor(white: 0, alpha: 0)
        return lbl
    }()
    
    private lazy var categoryNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Важное"
        lbl.font = UIFont(name: "SFPro-Regular", size: 17)
        lbl.textColor = UIColor(named: "ypGray")
        lbl.backgroundColor = UIColor(white: 0, alpha: 0)
        return lbl
    }()
    
    private lazy var chevronImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Chevron")
        imageView.contentMode = .right
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
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont(name:"SFPro-Medium", size: 16)
        btn.backgroundColor = UIColor(white: 0, alpha: 0)
        btn.layer.cornerRadius = 16
        btn.addTarget(self, action: #selector(categoryButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var containerViewScheduleButton: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0)
        view.isHidden = typeTracker == .event
        return view
    }()
    
    private lazy var scheduleButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.font = UIFont(name:"SFPro-Medium", size: 16)
        btn.backgroundColor = UIColor(white: 0, alpha: 0)
        btn.layer.cornerRadius = 16
        return btn
    }()
    
    private lazy var scheduleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Расписание"
        lbl.font = UIFont(name: "SFPro-Regular", size: 17)
        return lbl
    }()
    
    private lazy var scheduleSelectedLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Сб, Вс"
        lbl.font = UIFont(name: "SFPro-Regular", size: 17)
        lbl.textColor = UIColor(named: "ypGray")
        return lbl
    }()
    
    private lazy var stackScheduleButtonLabels: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.backgroundColor = UIColor(named: "backgroundField")
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
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Отменить", for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        btn.layer.borderColor = UIColor(named: "ypRed")?.cgColor
        btn.setTitleColor(UIColor(named: "ypRed"), for: .normal)
        btn.tintColor = .black
        btn.layer.borderWidth = 1
        btn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var createButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Создать", for: .normal)
        btn.backgroundColor = .gray
        btn.layer.cornerRadius = 16
        btn.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return btn
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
        scrollView.addGestureRecognizer(tapGesture)
        
        emojisAndColorsCollectionView.delegate = self
        emojisAndColorsCollectionView.dataSource = self
        emojisAndColorsCollectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.idCell)
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
        if typeTracker == .habit {
            stackButtons.addSeparators(color: UIColor(named: "ypGray") ?? UIColor(ciColor: .gray), thickness: 1)
        }
        contentView.addSubview(stackButtons)
        
        containerViewCategoryButton.addSubview(stackCategoryButtonLabels)
        containerViewCategoryButton.addSubview(chevronImage)
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
            
            chevronImage.topAnchor.constraint(equalTo: containerViewCategoryButton.topAnchor),
            chevronImage.trailingAnchor.constraint(equalTo: containerViewCategoryButton.trailingAnchor),
            chevronImage.bottomAnchor.constraint(equalTo: containerViewCategoryButton.bottomAnchor),
            chevronImage.widthAnchor.constraint(equalToConstant: 56),
            
            categoryLabel.heightAnchor.constraint(equalToConstant: 22),
            categoryNameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            stackCategoryButtonLabels.leadingAnchor.constraint(equalTo: containerViewCategoryButton.leadingAnchor),
            stackCategoryButtonLabels.topAnchor.constraint(equalTo: containerViewCategoryButton.topAnchor, constant: 15),
            stackCategoryButtonLabels.bottomAnchor.constraint(equalTo: containerViewCategoryButton.bottomAnchor, constant: -14),
            stackCategoryButtonLabels.trailingAnchor.constraint(equalTo: chevronImage.leadingAnchor),
            
            categoryButton.leadingAnchor.constraint(equalTo: containerViewCategoryButton.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: containerViewCategoryButton.trailingAnchor),
            categoryButton.topAnchor.constraint(equalTo: containerViewCategoryButton.topAnchor),
            categoryButton.bottomAnchor.constraint(equalTo: containerViewCategoryButton.bottomAnchor),
            
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
    
    @objc private func categoryButtonTapped() {
        print("categoryButtonTapped")
    }
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func createButtonTapped() {
        print("createButtonTapped")
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
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        errorLimitSumbolsLabel.isHidden = true
        return true
    }
}

extension TrackerViewController: UICollectionViewDelegate {
    
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
}

extension TrackerViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.idCell, for: indexPath) as? EmojiCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        if indexPath.section == 0 {
            cell.configure(emoji: emojis[indexPath.row], color: nil)
        } else {
            cell.configure(emoji: "", color: colors[indexPath.row])
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
        if indexPath.section == 0 {
            view.configure(headerText: "Emoji")
        } else {
            view.configure(headerText: "Цвет")
        }
        
        return view
    }
    
}
