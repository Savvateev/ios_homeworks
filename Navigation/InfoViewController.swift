import UIKit
import SnapKit

class InfoViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка фильма.."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private let orbitalPeriodLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка планеты.."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .darkGray
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        fetchData()
    }

    private func setupLayout() {
        [titleLabel, orbitalPeriodLabel].forEach { view.addSubview($0) }

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        orbitalPeriodLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }

    private func fetchData() {
        // JSONSerialization — title фильма
        NetworkService.requestFilmTitle { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let title):
                    self?.titleLabel.text = "Фильм: \(title)"
                case .failure(let error):
                    self?.titleLabel.text = "Ошибка: \(error.localizedDescription)"
                }
            }
        }

        // JSONDecoder — orbitalPeriod Татуина
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
