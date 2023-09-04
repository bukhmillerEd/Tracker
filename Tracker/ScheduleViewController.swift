
import UIKit

protocol SchedulebleDelegate: AnyObject {
    func selectedSchedule(daysSchedule: [Schedule])
}

final class ScheduleViewController: UIViewController {
    
    private var daysSchedule: [Schedule]
    private weak var delegate: SchedulebleDelegate?
    
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
        label.text = "Расписание"
        label.font = UIFont(name: "SFPro-Medium", size: 16)
        return label
    }()
    
    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 0
        stack.backgroundColor = UIColor(named: "backgroundField")
        stack.layer.cornerRadius = 16
        return stack
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont(name:"SFPro-Medium", size: 16)
        button.backgroundColor = .black
        button.tintColor = .white
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    
    init(daysSchedule: [Schedule], delegate: SchedulebleDelegate) {
        self.daysSchedule = daysSchedule
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        addSubviews()
        applyConstreints()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stack)
        
        for day in Schedule.allCases {
            let itemSchedule = ScheduleItem(dayName: day.representation(),
                                            switchIsOn: daysSchedule.contains(day))
            { [weak self] isOd in
                guard let self else { return }
                isOd ? self.daysSchedule.append(day) : self.daysSchedule.removeAll{ $0 == day }
            }
            stack.addArrangedSubview(itemSchedule)
        }
        stack.addSeparators(color: UIColor(named: "ypGray") ?? UIColor(ciColor: .gray), thickness: 1)
        contentView.addSubview(doneButton)
    }
    
    private func applyConstreints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 810),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.heightAnchor.constraint(equalToConstant: 525),
            
            doneButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            doneButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 39),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func doneTapped() {
        delegate?.selectedSchedule(daysSchedule: daysSchedule.sorted(by: {$0.rawValue < $1.rawValue}))
        dismiss(animated: true)
    }
}
