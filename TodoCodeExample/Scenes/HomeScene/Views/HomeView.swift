import UIKit
import SnapKit

final class HomeView: UIView {
    
    // MARK: - Callbacks
    var onAddButtonTapped: (() -> Void)?
    var onCellTapped: ((IndexPath) -> Void)?
    var onCheckmarkTapped: ((IndexPath) -> Void)?
    var onDeleteTapped: ((IndexPath) -> Void)?
    var onSearchTextChanged: ((String) -> Void)?
    
    // MARK: - UI Components
    
    // Navigation Bar (кастомная, если нужна)
    private let navigationBarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        return view
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Задачи"
        lbl.font = .systemFont(ofSize: 34, weight: .bold)
        lbl.textColor = .white
        return lbl
    }()
    
    let addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        btn.tintColor = .systemYellow
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        return btn
    }()
    
    // Search Bar
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Search"
        sb.searchBarStyle = .minimal
        sb.tintColor = .systemYellow
        sb.barTintColor = .black
        sb.backgroundColor = .black
        
        // Кастомизация текстового поля
        if let textField = sb.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.2)
            textField.textColor = .white
            textField.leftView?.tintColor = .systemGray
            
            // Placeholder цвет
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [.foregroundColor: UIColor.systemGray]
            )
        }
        
        return sb
    }()
    
    // Table View
    let tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .black
        tv.separatorStyle = .singleLine
        tv.separatorColor = .systemGray5
        tv.separatorInset = UIEdgeInsets(top: 0, left: 56, bottom: 0, right: 0)
        tv.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 80
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    // Empty State View
    private let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()
    
    private let emptyStateImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "checkmark.circle")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let emptyStateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Нет задач"
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        lbl.textColor = .systemGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    private let emptyStateSubtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Нажмите + чтобы добавить новую задачу"
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = .systemGray2
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    // Loading View
    private lazy var loadingView = LoadingView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UISearchBarDelegate
extension HomeView: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        onSearchTextChanged?(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        onSearchTextChanged?("")
    }
}

//MARK: - Private Methods
private extension HomeView {
    func setupUI() {
        backgroundColor = .black
        
        addSubview(navigationBarContainer)
        navigationBarContainer.addSubview(titleLabel)
        navigationBarContainer.addSubview(addButton)
        
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(emptyStateView)
        
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(emptyStateSubtitleLabel)
        
        addSubview(loadingView)
        
        setupConstraints()
    }
    
     func setupConstraints() {
        navigationBarContainer.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(52)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(navigationBarContainer.snp.leading).offset(16)
            make.centerY.equalTo(navigationBarContainer.snp.centerY)
            make.trailing.lessThanOrEqualTo(addButton.snp.leading).offset(-16)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalTo(navigationBarContainer.snp.trailing).inset(16)
            make.centerY.equalTo(navigationBarContainer.snp.centerY)
            make.width.height.equalTo(28)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(navigationBarContainer.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        emptyStateImageView.snp.makeConstraints { make in
            make.centerX.equalTo(emptyStateView.snp.centerX)
            make.centerY.equalTo(emptyStateView.snp.centerY).offset(-60)
            make.width.height.equalTo(80)
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyStateImageView.snp.bottom).offset(20)
            make.leading.equalTo(emptyStateView.snp.leading).offset(40)
            make.trailing.equalTo(emptyStateView.snp.trailing).inset(40)
        }
        
        emptyStateSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyStateLabel.snp.bottom).offset(8)
            make.leading.equalTo(emptyStateView.snp.leading).offset(40)
            make.trailing.equalTo(emptyStateView.snp.trailing).inset(40)
        }
        
        loadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        searchBar.delegate = self
    }
}

//MARK: Actions
private extension HomeView {
    @objc func addButtonTapped() {
        onAddButtonTapped?()
    }
}

//MARK: - Internal methods
extension HomeView {
    func showEmptyState(_ show: Bool) {
        emptyStateView.isHidden = !show
        tableView.isHidden = show
    }
    
    func showLoading() {
        loadingView.show(in: self)
    }
    
    func hideLoading() {
        loadingView.hide()
    }
    
    func clearSearch() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
