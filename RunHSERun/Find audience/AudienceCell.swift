import Foundation
import UIKit

final class AudienceCell : UITableViewCell {
    
    static let indentifier = "AudienceCell"
    
    private lazy var id : Int = 0
    
    private lazy var number : UILabel = {
        let number = UILabel()
        number.font = UIFont.systemFont(ofSize: 35, weight: .regular)
        number.textAlignment = .center
        number.textColor = .systemBlue
        number.translatesAutoresizingMaskIntoConstraints = false
        return number
    } ()
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: Self.indentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: Room) {
        number.text = data.code
    }
    
    private func configureUI() {
        contentView.addSubview(number)

        NSLayoutConstraint.activate([
            number.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            number.heightAnchor.constraint(equalToConstant: 40),
            number.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            number.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
}

