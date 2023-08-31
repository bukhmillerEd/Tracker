import UIKit

final class ScheduleItem: UIView {
    
    private var dayName: String
    private var switchIsOn: Bool
    private var switchChangeProcessing: ((Bool) -> ())
    
    private lazy var dayNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = dayName
        label.font = UIFont(name: "SFPro-Regular", size: 17)
        return label
    }()
    
    private lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.translatesAutoresizingMaskIntoConstraints = false
        switchButton.addTarget(self, action: #selector(switchWasChenged), for: .touchUpInside)
        switchButton.isOn = switchIsOn
        switchButton.onTintColor = UIColor(named: "switchColor")
        return switchButton
    }()
    
    init(dayName: String, switchIsOn: Bool, switchChangeProcessing: @escaping (Bool) -> ()) {
        self.dayName = dayName
        self.switchIsOn = switchIsOn
        self.switchChangeProcessing = switchChangeProcessing
        super.init(frame: .zero)
        
        addSubviews()
        applyConstreints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func switchWasChenged() {
        switchChangeProcessing(switchButton.isOn)
    }
    
    private func addSubviews() {
        addSubview(dayNameLabel)
        addSubview(switchButton)
    }
    
    private func applyConstreints() {
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 75),
            
            switchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            switchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            dayNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dayNameLabel.trailingAnchor.constraint(equalTo: switchButton.leadingAnchor, constant: -16),
            dayNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
