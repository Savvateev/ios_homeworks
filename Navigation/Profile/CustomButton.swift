import UIKit

class CustomButton: UIButton {
    
    private var action: (() -> Void)?
    
    init(
        title: String,
        titleColor: UIColor = .white,
        bgColor: UIColor = .systemBlue,
        bgImage: UIImage? = nil,
        cornerRadius: CGFloat = 4,
        action: (() -> Void)?
    ) {
        self.action = action
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false

        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        backgroundColor = bgColor
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        titleLabel?.font = .systemFont(ofSize: 16)
        
        if let bgImage = bgImage {
            setBackgroundImage(bgImage, for: .normal)
            setBackgroundImage(bgImage.withAlpha(0.8), for: .highlighted)
            setBackgroundImage(bgImage.withAlpha(0.8), for: .selected)
        }
        
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        action?()
    }
}
