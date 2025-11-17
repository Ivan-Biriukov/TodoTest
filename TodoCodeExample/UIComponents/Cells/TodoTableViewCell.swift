import UIKit
import SnapKit

fileprivate struct Constants {
    let titleLabelFontSize: CGFloat = 17
    let titleLabelLineLimits: Int = 2
    
    let descriptionLabelFontSize: CGFloat = 14
    let descriptionLabelLineLimit: Int = 2
    
    let dateLabelFontSize: CGFloat = 12
    let containerStackViewSpacing: CGFloat = 4
    
    let checkmarkButtonLeadingOffset: CGFloat = 16
    let checkmarkButtonSize: CGFloat = 28
    
    let containerStackViewLeadingOffset: CGFloat = 12
    let containerStackViewTrailingInset: CGFloat = 16
    let containerStackViewTopOffset: CGFloat = 12
    let containerStackViewBottomInset: CGFloat = 12
}

final class TodoTableViewCell: UITableViewCell {
    static let reuseIdentifier = "TodoTableViewCell"
    
    var onCheckmarkTapped: (() -> Void)?
    
    private let k = Constants()
    
    // MARK: - UI Components
    private lazy var  checkmarkButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.tintColor = .systemYellow
        btn.setImage(UIImage(systemName: "circle"), for: .normal)
        btn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: k.titleLabelFontSize, weight: .medium)
        lbl.textColor = .white
        lbl.numberOfLines = k.titleLabelLineLimits
        return lbl
    }()
    
    private lazy var  descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: k.descriptionLabelFontSize, weight: .regular)
        lbl.textColor = .systemGray
        lbl.numberOfLines = k.descriptionLabelLineLimit
        return lbl
    }()
    
    private lazy var  dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: k.dateLabelFontSize, weight: .regular)
        lbl.textColor = .systemGray2
        return lbl
    }()
    
    private lazy var  containerStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = k.containerStackViewSpacing
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
            make.leading.equalToSuperview().offset(k.checkmarkButtonLeadingOffset)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(k.checkmarkButtonSize)
        }
        
        containerStackView.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkButton.snp.trailing).offset(k.containerStackViewLeadingOffset)
            make.trailing.equalToSuperview().inset(k.containerStackViewTrailingInset)
            make.top.equalToSuperview().offset(k.containerStackViewTopOffset)
            make.bottom.equalToSuperview().inset(k.containerStackViewBottomInset)
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
