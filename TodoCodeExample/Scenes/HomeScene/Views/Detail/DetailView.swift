import UIKit
import SnapKit

fileprivate struct Constants {
    let titleLableFontSize: CGFloat = 34
    let titleLabelLineLimit: Int = 1
    let labelsLineLimit: Int = 0
    let dateLabelFontSize: CGFloat = 14
    let textViewFontSize: CGFloat = 17
    let complitLabelFontSize: CGFloat = 17
    
    let titleLabelTopOffse: CGFloat = 20
    let titleLabelLeadingOffset: CGFloat = 16
    let titleLabelTrailingInset: CGFloat = 16
    
    let dateLabelTopOffset: CGFloat = 8
    let dateLabelLeadingOffset: CGFloat = 16
    let dateLabelTrailingInset: CGFloat = 16
    
    let textViewTopOffset: CGFloat = 32
    let textViewLeadingOffset: CGFloat = 16
    let textViewTrailingInsets: CGFloat = 16
    let textViewMinHeight: CGFloat = 150
    
    let completedLabelTopOffset: CGFloat = 40
    let completedLabelLeadingOffset: CGFloat = 16
    let completedLabelBottomInsets: CGFloat = 20
    
    let completedSwitchTrailingInsets: CGFloat = 16
}

//MARK: - DetailView
final class DetailView: UIView {
    var onSaveTapped: (() -> Void)?
    var onTextChanged: ((String) -> Void)?
    
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
        lbl.numberOfLines = k.titleLabelLineLimit
        return lbl
    }()
    
    private lazy var dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: k.dateLabelFontSize)
        lbl.textColor = .systemGray2
        return lbl
    }()
    
    lazy var descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: k.textViewFontSize)
        tv.textColor = .white
        tv.backgroundColor = .clear
        tv.layer.cornerRadius = 12
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tv.isScrollEnabled = false
        return tv
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
        contentView.addSubview(descriptionTextView)
        contentView.addSubview(completedLabel)
        contentView.addSubview(completedSwitch)
        
        completedSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        descriptionTextView.delegate = self
        
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
        
        descriptionTextView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(k.textViewTopOffset)
            make.leading.equalToSuperview().offset(k.textViewLeadingOffset)
            make.trailing.equalToSuperview().inset(k.textViewTrailingInsets)
            make.height.greaterThanOrEqualTo(k.textViewMinHeight)
        }
        
        completedLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextView.snp.bottom).offset(k.completedLabelTopOffset)
            make.leading.equalToSuperview().offset(k.completedLabelLeadingOffset)
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
        titleLabel.text = "Task id is \(todo.id.uuidString)"
        
        completedSwitch.isOn = todo.isComplited
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateLabel.text = dateFormatter.string(from: todo.creationDate)
        
        descriptionTextView.text = todo.todoDescription
    }
}

// MARK: - UITextViewDelegate
extension DetailView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        onTextChanged?(textView.text)
    }
}
