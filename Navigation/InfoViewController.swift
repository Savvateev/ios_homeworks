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
        fetchPlanet()
    }

    private func setupLayout() {
        view.addSubview(orbitalPeriodLabel)
        orbitalPeriodLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func fetchPlanet() {
        NetworkService.requestPlanet { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let planet):
                    self?.orbitalPeriodLabel.text = "Период обращения Татуина: \(planet.orbitalPeriod) дней"
                case .failure(let error):
                    self?.orbitalPeriodLabel.text = "Ошибка: \(error.localizedDescription)"
                }
            }
        }
    }
}
