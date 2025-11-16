import UIKit
import SnapKit

final class LoadingView: UIView {
    // MARK: - UI Components
    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .systemYellow
        return indicator
    }()
    
    private let messageLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = .systemFont(ofSize: 16, weight: .medium)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.text = "Загрузка..."
        return lbl
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private methods
private extension LoadingView {
    func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        addSubview(blurEffectView)
        addSubview(activityIndicator)
        addSubview(messageLabel)
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(activityIndicator.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().offset(20)
            make.trailing.lessThanOrEqualToSuperview().inset(20)
        }
    }
}

//MARK: - Internal methods
extension LoadingView {
    func show(in view: UIView, message: String = "Загрузка...") {
        messageLabel.text = message
        
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        self.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        alpha = 0
        activityIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    
    func hide(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }) { _ in
            self.activityIndicator.stopAnimating()
            self.removeFromSuperview()
            completion?()
        }
    }
}
