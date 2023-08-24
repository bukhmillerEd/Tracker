
import UIKit

protocol CreatableAndEditableTrackerDelegate: AnyObject {
    func createTracker(tracker: Tracker)
}

final class AdditingTrackerViewController: UIViewController {
    
    weak var delegate: CreatableAndEditableTrackerDelegate? = nil
    
    private lazy var habitButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Привычка", for: .normal)
        btn.titleLabel?.font = UIFont(name:"SFPro-Medium", size: 16)
        btn.backgroundColor = .black
        btn.tintColor = .white
        btn.layer.cornerRadius = 16
        btn.addTarget(self, action: #selector(addHabit), for: .touchUpInside)
        return btn
    }()
    
    private lazy var eventButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Нерегулярное событие", for: .normal)
        btn.titleLabel?.font = UIFont(name:"SFPro-Medium", size: 16)
        btn.backgroundColor = .black
        btn.tintColor = .white
        btn.layer.cornerRadius = 16
        btn.addTarget(self, action: #selector(addEvent), for: .touchUpInside)
        return btn
    }()
    
    private lazy var stackButtons: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Создание трекера"
        lbl.font = UIFont(name: "SFPro-Medium", size: 16)
        return lbl
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
        vc.completionHandler = { [weak self] tracker in
            guard let tracker, let self else { return }
            self.delegate?.createTracker(tracker: tracker)
            self.dismiss(animated: true)
        }
        present(vc, animated: true)
    }
    
}
