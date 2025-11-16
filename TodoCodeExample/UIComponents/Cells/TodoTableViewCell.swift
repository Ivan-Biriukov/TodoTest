import UIKit
import SnapKit

final class TodoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TodoTableViewCell"
    
    var onCheckmarkTapped: (() -> Void)?
    
    // MARK: - UI Components
    private let checkmarkButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemYellow
        btn.setImage(UIImage(systemName: "circle"), for: .normal)
        btn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        return btn
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 17, weight: .medium)
        lbl.textColor = .white
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = .systemGray
        lbl.numberOfLines = 2
        return lbl
    }()
    
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 12, weight: .regular)
        lbl.textColor = .systemGray2
        return lbl
    }()
    
    private let containerStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 4
        sv.alignment = .leading
        return sv
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.attributedText = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        dateLabel.text = nil
        checkmarkButton.isSelected = false
        onCheckmarkTapped = nil
    }
}

//MARK: - private methods
private extension TodoTableViewCell {
    private func setupUI() {
        backgroundColor = .black
        selectionStyle = .none
        
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(dateLabel)
        
        checkmarkButton.addTarget(self, action: #selector(checkmarkTapped), for: .touchUpInside)
        
        checkmarkButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(28)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkButton.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
    
    private func updateCheckmarkAppearance(completed: Bool) {
        checkmarkButton.isSelected = completed
        
        if completed {
            titleLabel.attributedText = NSAttributedString(
                string: titleLabel.text ?? "",
                attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            )
            titleLabel.textColor = .systemGray
        } else {
            titleLabel.attributedText = NSAttributedString(string: titleLabel.text ?? "")
            titleLabel.textColor = .white
        }
    }
}

//MARK: - internal methods
extension TodoTableViewCell {
    func configure(with todo: UITodoItem) {
        titleLabel.text = todo.todoDescription
        
        // Показываем/скрываем description (у вас пока нет в модели, но можно добавить)
        descriptionLabel.isHidden = true // todo.taskDescription?.isEmpty ?? true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateLabel.text = dateFormatter.string(from: todo.creationDate)
        
        updateCheckmarkAppearance(completed: todo.isComplited)
    }
}

//MARK: - Actions
private extension TodoTableViewCell {
    @objc func checkmarkTapped() {
        onCheckmarkTapped?()
    }
}
