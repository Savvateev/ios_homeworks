import UIKit
import StorageService
import SnapKit
import iOSIntPackage

class PostTableViewCell: UITableViewCell {
    
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

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods
    
    func configure(with post: Post) {
        authorLabel.text = post.author
        descriptionLabel.text = post.description
        likesLabel.text = "Likes: \(post.likes)"
        viewsLabel.text = "Views: \(post.views)"
        
        // Загружаем оригинальное фото и применяем фильтр
        if let image = UIImage(named: post.image) {
            setupImageWithFilter(image)
        }
    }
    
    private func setupImageWithFilter(_ sourceImage: UIImage) {
        let processor = ImageProcessor()
        
        //  .chrome, .colorInvert, .noir, .fade, .tonal......
        processor.processImage(sourceImage: sourceImage, filter: .tonal) { [weak self] processedImage in
            self?.postImageView.image = processedImage
        }
    }

    private func setupLayout() {
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        [authorLabel, postImageView, descriptionLabel, likesLabel, viewsLabel].forEach {
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
        
        likesLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        
        viewsLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
