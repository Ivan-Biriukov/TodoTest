import UIKit
import SnapKit

final class DetailView: UIView {
    
    var onSaveTapped: (() -> Void)?
    var onDeleteTapped: (() -> Void)?
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.keyboardDismissMode = .interactive
        return sv
    }()
    
    private let contentView = UIView()
    
    // Заголовок задачи (большой, как на картинке)
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 34, weight: .bold)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // Дата создания
    private let dateLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14)
        lbl.textColor = .systemGray2
        return lbl
    }()
    
    // Описание (из картинки - это текстовый блок)
    private let descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 17)
        lbl.textColor = .white
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // Свитч "Выполнено"
    let completedSwitch: UISwitch = {
        let sw = UISwitch()
        sw.onTintColor = .systemYellow
        return sw
    }()
    
    private let completedLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Отметить как выполненное"
        lbl.font = .systemFont(ofSize: 17)
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
        
        // Добавляем слушатель на изменение свитча
        completedSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        completedLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(16)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
        
        completedSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(completedLabel)
            make.trailing.equalToSuperview().inset(16)
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
        
        // Описание пока пустое (можно расширить модель позже)
        descriptionLabel.text = "Составить список необходимых продуктов для ужина. Не забыть проверить, что уже есть в холодильнике."
    }
}
