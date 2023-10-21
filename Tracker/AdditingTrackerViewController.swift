
import UIKit

protocol CreatableAndEditableTrackerDelegate: AnyObject {
    func createTracker(tracker: Tracker, inCategoryWithTitle titleCategory: String)
}

final class AdditingTrackerViewController: UIViewController {
    
    weak var delegate: CreatableAndEditableTrackerDelegate? = nil
    
    private lazy var habitButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = UIFont(name:"SFPro-Medium", size: 16)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addHabit), for: .touchUpInside)
        return button
    }()
    
    private lazy var eventButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = UIFont(name:"SFPro-Medium", size: 16)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(addEvent), for: .touchUpInside)
        return button
    }()
    
    private lazy var stackButtons: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Создание трекера"
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(stackButtons)
        view.addSubview(titleLabel)
        
        stackButtons.addArrangedSubview(habitButton)
        stackButtons.addArrangedSubview(eventButton)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            stackButtons.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackButtons.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackButtons.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func addHabit() {
        showViewNewTracker(typeTracker: .habit)
    }
    
    @objc private func addEvent() {
        showViewNewTracker(typeTracker: .event)
    }
    
    private func showViewNewTracker(typeTracker: TypeTracker) {
        let vc = TrackerViewController(typeTracker: typeTracker)
        vc.completionHandler = { [weak self] tracker, titleCategory in
            guard let tracker, let titleCategory, let self else { return }
            self.delegate?.createTracker(tracker: tracker, inCategoryWithTitle: titleCategory)
            self.dismiss(animated: true)
        }
        present(vc, animated: true)
    }
    
}
