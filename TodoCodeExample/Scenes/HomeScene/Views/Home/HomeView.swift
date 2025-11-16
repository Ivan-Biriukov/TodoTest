import UIKit
import SnapKit

fileprivate struct Constants {
    let titleLabelFontSize: CGFloat = 34
    let tableSeporaterEdgeInsets: UIEdgeInsets = .init(top: 0, left: 20, bottom: 0, right: 20)
    let tableEstimatedRowHeight: CGFloat = 80
    let emptyLabelFontSize: CGFloat = 20
    let emptyStateSubtitleFontSize: CGFloat = 14
    
    let navBarContainerHeight: CGFloat = 52
    let titleLabelHOffsets: CGFloat = 16
    
    let addButtonTrailingInsets: CGFloat = 20
    let addButtonSize: CGFloat = 28
    let addButtonTopOffset: CGFloat = 10
    let searchBarHeight: CGFloat = 56
    
    let emptyStateImageViewCentYOffset: CGFloat = 60
    let emptyStateImageViewHeight: CGFloat = 80
    
    let emptyStateLabelTopOffset: CGFloat = 20
    let emptyStateLabelLeadingOffset: CGFloat = 40
    let emptyStateLabelTrailingInsets: CGFloat = 40
    
    let emptyStateSubtitleLabelTopOffset: CGFloat = 8
    let emptyStateSubtitleLabelLeadingOffset: CGFloat = 40
    let emptyStateSubtitleLabelTrailingInset: CGFloat = 40
    
    let centerLabelFontSize: CGFloat = 11
    let centerLabelTopOffset: CGFloat = 20
    
    let customTabBarHeight: CGFloat = 83
}

//MARK: - HomeView
final class HomeView: UIView {
    var onAddButtonTapped: (() -> Void)?
    var onCellTapped: ((IndexPath) -> Void)?
    var onCheckmarkTapped: ((IndexPath) -> Void)?
    var onDeleteTapped: ((IndexPath) -> Void)?
    var onSearchTextChanged: ((String) -> Void)?
    
    private let k = Constants()
    
    // MARK: - UI Components
    private lazy var navigationBarContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Задачи"
        lbl.font = .systemFont(ofSize: k.titleLabelFontSize, weight: .bold)
        lbl.textColor = .white
        return lbl
    }()
    
    private lazy var addButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        btn.tintColor = .systemYellow
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        return btn
    }()
    
    // Search Bar
    private lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Search"
        sb.searchBarStyle = .minimal
        sb.tintColor = .systemYellow
        sb.barTintColor = .black
        sb.backgroundColor = .black
        
        
        if let textField = sb.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = UIColor.TodoColors.bgGray
            textField.textColor = .white
            textField.leftView?.tintColor = .systemGray
            
            textField.attributedPlaceholder = NSAttributedString(
                string: "Search",
                attributes: [.foregroundColor: UIColor.systemGray]
            )
        }
        
        return sb
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = .black
        tv.separatorStyle = .singleLine
        tv.separatorColor = .systemGray5
        tv.separatorInset = k.tableSeporaterEdgeInsets
        tv.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.reuseIdentifier)
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = k.tableEstimatedRowHeight
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    // Empty State View
    private lazy var emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()
    
    private lazy var emptyStateImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "checkmark.circle")
        iv.tintColor = .systemGray3
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var emptyStateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Нет задач"
        lbl.font = .systemFont(ofSize: k.emptyLabelFontSize, weight: .medium)
        lbl.textColor = .systemGray
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var emptyStateSubtitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Нажмите + чтобы добавить новую задачу"
        lbl.font = .systemFont(ofSize: k.emptyStateSubtitleFontSize, weight: .regular)
        lbl.textColor = .systemGray2
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private lazy var customTabBar: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.TodoColors.bgGray
        return v
    }()

    private lazy var centerLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "7 задач"
        lbl.textColor = UIColor.TodoColors.textWhite
        lbl.font = .systemFont(ofSize: k.centerLabelFontSize, weight: .regular)
        return lbl
    }()
    
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
        
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(emptyStateView)
        
        emptyStateView.addSubview(emptyStateImageView)
        emptyStateView.addSubview(emptyStateLabel)
        emptyStateView.addSubview(emptyStateSubtitleLabel)
        
        addSubview(loadingView)
        
        addSubview(customTabBar)
        customTabBar.addSubview(centerLabel)
        customTabBar.addSubview(addButton)
        
        setupConstraints()
        
        let bottomInset = k.customTabBarHeight + safeAreaInsets.bottom
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomInset, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    func setupConstraints() {
        navigationBarContainer.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(k.navBarContainerHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(navigationBarContainer.snp.leading).offset(k.titleLabelHOffsets)
            make.centerY.equalTo(navigationBarContainer.snp.centerY)
            make.trailing.lessThanOrEqualTo(addButton.snp.leading).offset(-k.titleLabelHOffsets)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(customTabBar.snp.top).offset(k.addButtonTopOffset)
            make.trailing.equalToSuperview().inset(k.addButtonTrailingInsets)
            make.width.height.equalTo(k.addButtonSize)
        }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(navigationBarContainer.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(k.searchBarHeight)
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
            make.centerY.equalTo(emptyStateView.snp.centerY).offset(-k.emptyStateImageViewCentYOffset)
            make.width.height.equalTo(k.emptyStateImageViewHeight)
        }
        
        emptyStateLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyStateImageView.snp.bottom).offset(k.emptyStateLabelTopOffset)
            make.leading.equalTo(emptyStateView.snp.leading).offset(k.emptyStateLabelLeadingOffset)
            make.trailing.equalTo(emptyStateView.snp.trailing).inset(k.emptyStateLabelTrailingInsets)
        }
        
        emptyStateSubtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(emptyStateLabel.snp.bottom).offset(k.emptyStateSubtitleLabelTopOffset)
            make.leading.equalTo(emptyStateView.snp.leading).offset(k.emptyStateSubtitleLabelLeadingOffset)
            make.trailing.equalTo(emptyStateView.snp.trailing).inset(k.emptyStateSubtitleLabelTrailingInset)
        }
        
        customTabBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(k.customTabBarHeight)
        }
        
        centerLabel.snp.makeConstraints { make in
            make.top.equalTo(customTabBar.snp.top).offset(k.centerLabelTopOffset)
            make.centerX.equalToSuperview()
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
    
    func updateCenterLabel(with todosCount: Int) {
        let text: String
        switch todosCount {
        case 0:
            text = "Нет задач"
        case 1:
            text = "1 задача"
        case 2...4:
            text = "\(todosCount) задачи"
        default:
            text = "\(todosCount) задач"
        }
        centerLabel.text = text
    }
}
