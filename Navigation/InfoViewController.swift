import UIKit
import SnapKit

class InfoViewController: UIViewController {

    private let orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didReceiveOrbitalPeriod(_:)),
            name: NSNotification.Name("OrbitalPeriodReceived"),
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupLayout() {
        view.addSubview(orbitalPeriodLabel)
        orbitalPeriodLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    @objc private func didReceiveOrbitalPeriod(_ notification: Notification) {
        guard let period = notification.userInfo?["orbitalPeriod"] as? String else { return }
        orbitalPeriodLabel.text = "Период обращения Татуина: \(period) дней"
    }
}
