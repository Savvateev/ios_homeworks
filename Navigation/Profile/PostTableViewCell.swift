import UIKit
import StorageService
import SnapKit

class PostTableViewCell: UITableViewCell {

    // MARK: - Состояние и колбэки

    private var post: Post?
    var onDoubleTap: ((_ post: Post) -> Void)?

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.numberOfLines = 1
        return label
    }()

    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Иконки из ассетов

    private let likesIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "heart")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let viewsIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "eye")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let viewsLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        setupGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with post: Post) {
        self.post = post
        authorLabel.text = post.author
        descriptionLabel.text = post.description
        likesLabel.text = "\(post.likes)"
        viewsLabel.text = "\(post.views)"
        postImageView.image = UIImage(named: post.image) ?? UIImage()
        //postImageView.image = UIImage(named: post.image)

        // Есть лайки → красное сердечко, нет → обычное
        likesIconImageView.image = UIImage(named: post.likes > 0 ? "red_heart" : "heart")
    }

    // MARK: - Жест «двойной тап» (UIGestureRecognizer)

    private func setupGestureRecognizer() {
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecognizer)
    }

    @objc private func doubleTapped() {
        guard let post = post else { return }
        onDoubleTap?(post)
    }

    // MARK: - Layout

    private func setupLayout() {
        setupHierarchy()
        setupConstraints()
    }

    private func setupHierarchy() {
        [authorLabel, postImageView, descriptionLabel,
         likesIconImageView, likesLabel,
         viewsIconImageView, viewsLabel].forEach {
            contentView.addSubview($0)
        }
    }

    private func setupConstraints() {
        authorLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(16)
        }

        postImageView.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(contentView.snp.width)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        // Группа «лайков» прижата к левому краю: [♥] 10
        likesIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(likesLabel.snp.centerY)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }

        likesLabel.snp.makeConstraints { make in
            make.leading.equalTo(likesIconImageView.snp.trailing).offset(6)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        // Группа «просмотров» прижата к правому краю: 5 [👁]
        viewsIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(viewsLabel.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }

        viewsLabel.snp.makeConstraints { make in
            make.trailing.equalTo(viewsIconImageView.snp.leading).offset(-6)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
