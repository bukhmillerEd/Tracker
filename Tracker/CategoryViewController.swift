import UIKit

final class CategoryViewController: UIViewController {
    
    private lazy var nameTextField: TextFieldWidthPadding = {
        let field = TextFieldWidthPadding(paddingTop: 0, paddingBottom: 0, paddingLeft: 16, paddingRight: 16)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.placeholder = "Введите название категории"
        field.layer.cornerRadius = 16
        field.text = viewModel?.nameBeforeEdit
        field.backgroundColor = UIColor(named: "backgroundField")
        field.clearButtonMode = .whileEditing
        return field
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel?.title
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.layer.cornerRadius = 16
        button.titleLabel?.font = UIFont(name: "SFPro-Medium", size: 16)
        button.tintColor = .white
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private var viewModel: CategoryViewModel?
    private var completionHandler: () -> ()
    
    init(typeOperation: TypeOperation, completionHandler: @escaping () -> ()) {
        self.completionHandler = completionHandler
        super.init(nibName: nil, bundle: nil)
       
        switch typeOperation {
        case .editingCategory(let nameCategory):
            viewModel = CategoryViewModel(typeOperation: typeOperation, nameForEdit: nameCategory)
        case .newCategory:
            viewModel = CategoryViewModel(typeOperation: typeOperation, nameForEdit: "")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        activateDoneButton(nameTextField.text?.count ?? 0 > 0)
        addSubviews()
    }
    
    @objc private func doneButtonTapped() {
        viewModel?.saveCategory(name: nameTextField.text ?? "")
        dismiss(animated: true)
        completionHandler()
    }
    
    private func addSubviews() {
        view.addSubview(nameTextField)
        view.addSubview(titleLabel)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func activateDoneButton(_ activate: Bool) {
        doneButton.isEnabled = activate
        doneButton.backgroundColor = activate ? .black : .gray
    }
    
}

extension CategoryViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        activateDoneButton(textField.text?.count ?? 0 > 0)
    }
}
