
import UIKit

protocol ExecutionManagerDelegate: AnyObject {
    func executionСontrol(id: UUID)
}

final class TrackerViewCell: UICollectionViewCell {
    
    static let cellID = "cellID"
    
    private var viewModel: TrackerCellViewModel? {
        didSet {
            trackerView.backgroundColor = viewModel?.color
            nameLabel.text = viewModel?.name ?? ""
            emojiLabel.text = viewModel?.emoji ?? ""
            counterLabel.text = "\(viewModel?.counter ?? 0) \(viewModel?.counter.days() ?? "")"
            doneButton.backgroundColor = viewModel?.color
            doneButton.isEnabled = viewModel?.doneButtonIsEnabled ?? false
            doneButton.layer.opacity = viewModel?.doneButtonIsEnabled ?? false == true ? 1 : 0.3
            var image: UIImage? = nil
            if let trackerIsDone = viewModel?.trackerIsDone, trackerIsDone {
                image = UIImage(systemName: "checkmark")
            } else {
                image = UIImage(systemName: "plus")
            }
            doneButton.setImage(image?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        }
    }
    
    private lazy var trackerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .white
        lbl.font = UIFont(name: "SFPro-Medium", size: 12)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private lazy var  emojiLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "SFPro-Medium", size: 16)
        return lbl
    }()
    
    private lazy var emojiView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.backgroundColor = .white.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "pin.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    private lazy var managementView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var  counterLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont(name: "SFPro-Medium", size: 12)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private lazy var doneButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(systemName: "plus")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        btn.setImage(image, for: .normal)
        btn.layer.cornerRadius = 17
        btn.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    weak var delegate: ExecutionManagerDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(trackerView)
        contentView.addSubview(managementView)
        trackerView.addSubview(nameLabel)
        trackerView.addSubview(emojiView)
        trackerView.addSubview(pinImageView)
        emojiView.addSubview(emojiLabel)
        managementView.addSubview(counterLabel)
        managementView.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            
            managementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            managementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            managementView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            managementView.heightAnchor.constraint(equalToConstant: 58),
            
            nameLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            
            emojiView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),
            
            pinImageView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 18),
            pinImageView.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            pinImageView.heightAnchor.constraint(equalToConstant: 12),
            pinImageView.widthAnchor.constraint(equalToConstant: 8),
            
            doneButton.topAnchor.constraint(equalTo: managementView.topAnchor, constant: 8),
            doneButton.trailingAnchor.constraint(equalTo: managementView.trailingAnchor, constant: -12),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.widthAnchor.constraint(equalToConstant: 34),
            
            counterLabel.leadingAnchor.constraint(equalTo: managementView.leadingAnchor, constant: 12),
            counterLabel.topAnchor.constraint(equalTo: managementView.topAnchor, constant: 16),
            counterLabel.trailingAnchor.constraint(equalTo: doneButton.leadingAnchor, constant: -8)
        ])
    }
    
    func configure(model: TrackerCellViewModel) {
        self.viewModel = model
    }
    
    @objc func doneButtonTapped() {
        if let trackerIsDone = viewModel?.trackerIsDone, trackerIsDone  {
            viewModel?.counter -= 1
        } else {
            viewModel?.counter += 1
        }
        delegate?.executionСontrol(id: viewModel?.id ?? UUID())
        viewModel?.trackerIsDone.toggle()
    }
    
}
