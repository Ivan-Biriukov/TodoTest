import UIKit
import SnapKit

fileprivate struct Constants {
    let titleLableFontSize: CGFloat = 34
    let labelsLineLimit: Int = 0
    let dateLabelFontSize: CGFloat = 14
    let descrLabelFontSize: CGFloat = 17
    let complitLabelFontSize: CGFloat = 17
    
    let titleLabelTopOffse: CGFloat = 20
    let titleLabelLeadingOffset: CGFloat = 16
    let titleLabelTrailingInset: CGFloat = 16
    
    let dateLabelTopOffset: CGFloat = 8
    let dateLabelLeadingOffset: CGFloat = 16
    let dateLabelTrailingInset: CGFloat = 16
    
    let descriptionLabelTopOffset: CGFloat = 32
    let descriptionLabelLeadingOffset: CGFloat = 16
    let descriptionLabelTrailingInsets: CGFloat = 16
    
    let completedLabelTopOffset: CGFloat = 40
    let completedLabelLeadingOffset: CGFloat = 20
    let completedLabelBottomInsets: CGFloat = 20
    
    let completedSwitchTrailingInsets: CGFloat = 16
}

//MARK: - DetailView
final class DetailView: UIView {
    var onSaveTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    private let k = Constants()
    
    // MARK: - UI Components
    
    private lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    private lazy var contentView = UIView()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: k.titleLableFontSize, weight: .bold)
        lbl.textColor = .white
        lbl.numberOfLines = k.labelsLineLimit
        return lbl
    }()
    
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: k.dateLabelFontSize)
        lbl.textColor = .systemGray2
        return lbl
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: k.descrLabelFontSize)
        lbl.textColor = .white
        lbl.numberOfLines = k.labelsLineLimit
        return lbl
    }()
    
    lazy var completedSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .systemYellow
        return sw
    }()
    
    private lazy var completedLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Отметить как выполненное"
        lbl.font = .systemFont(ofSize: k.complitLabelFontSize)
        lbl.textColor = .white
        return lbl
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(completedLabel)
        contentView.addSubview(completedSwitch)
        
        completedSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(k.titleLabelTopOffse)
            make.leading.equalToSuperview().offset(k.titleLabelLeadingOffset)
            make.trailing.equalToSuperview().inset(k.titleLabelTrailingInset)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(k.dateLabelTopOffset)
            make.leading.equalToSuperview().offset(k.dateLabelLeadingOffset)
            make.trailing.equalToSuperview().inset(k.dateLabelTrailingInset)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(k.descriptionLabelTopOffset)
            make.leading.equalToSuperview().offset(k.descriptionLabelLeadingOffset)
            make.trailing.equalToSuperview().inset(k.descriptionLabelTrailingInsets)
        }
        
        completedLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(k.completedLabelTopOffset)
            make.leading.equalToSuperview().offset(k.completedLabelTopOffset)
            make.bottom.lessThanOrEqualToSuperview().inset(k.completedLabelBottomInsets)
        }
        
        completedSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(completedLabel)
            make.trailing.equalToSuperview().inset(k.completedSwitchTrailingInsets)
        }
    }
    
    @objc private func switchChanged() {
        onSaveTapped?()
    }
    
    func configure(with todo: UITodoItem) {
        titleLabel.text = todo.todoDescription
        completedSwitch.isOn = todo.isComplited
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateLabel.text = dateFormatter.string(from: todo.creationDate)
        
        descriptionLabel.text = "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."
    }
}
