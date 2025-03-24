//
//  CommentTableViewCell.swift
//  Todorama
//
//  Created by 권우석 on 3/23/25.
//

import UIKit
import SnapKit
import Kingfisher

final class CommentTableViewCell: UITableViewCell {
    
    // MARK: - UI Components
    private let containerView = UIView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let commentLabel = UILabel()
    private let dateLabel = UILabel()
    
    // 검색어 하이라이트를 위한 속성
    private var currentQuery: String = Strings.Global.empty.text
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        configureCell()
        configureHierarchy()
        configureLayout()
        configureComponents()
    }
    
    private func configureCell() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
    }
    
    private func configureHierarchy() {
        contentView.addSubview(containerView)
        
        [posterImageView, titleLabel, commentLabel, dateLabel].forEach {
            containerView.addSubview($0)
        }
    }
    
    private func configureLayout() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
        }
        
        posterImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(140)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(posterImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview().inset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(8)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(8)
            make.bottom.lessThanOrEqualToSuperview().inset(8)
        }
    }
    
    private func configureComponents() {
        // Container View
        containerView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
        containerView.layer.cornerRadius = 8
        containerView.clipsToBounds = true
        
        // Poster Image View
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.layer.cornerRadius = 4
        posterImageView.backgroundColor = .tdMain
        
        // Title Label
        titleLabel.dramaTitleStyle()
        
        // Date Label
        dateLabel.accessoryStyle()
        
        // Comment Label
        commentLabel.textStyle()
        commentLabel.numberOfLines = 3
    }
    
    // MARK: - Cell Configuration
    func configure(with item: CommentItem, searchQuery: String = Strings.Global.empty.text) {
        self.currentQuery = searchQuery.lowercased()
        
        // 제목과 코멘트에 검색어 하이라이트 적용
        if !currentQuery.isEmpty {
            highlightText(label: titleLabel, text: item.title)
            highlightText(label: commentLabel, text: item.comment)
        } else {
            titleLabel.text = item.title
            commentLabel.text = item.comment
        }
        
        // 날짜 형식 포맷팅
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        dateLabel.text = dateFormatter.string(from: item.date)
        
        // 이미지 로드
        if let posterPath = item.posterPath {
            let imageBase = "https://image.tmdb.org/t/p/w500"
            let url = URL(string: imageBase + posterPath)
            posterImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "film"))
        } else {
            // 더미 이미지 설정
            posterImageView.image = SystemImages.pencil.image
            posterImageView.backgroundColor = .tdMain
            posterImageView.contentMode = .center
            posterImageView.tintColor = .white
        }
    }
    
    // 검색어를 강조하는 메서드
    private func highlightText(label: UILabel, text: String) {
        guard !currentQuery.isEmpty else {
            label.text = text
            return
        }
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text.lowercased() as NSString).range(of: currentQuery)
        
        if range.location != NSNotFound {
            attributedString.addAttribute(.backgroundColor, value: UIColor.tdMain.withAlphaComponent(0.3), range: range)
            attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: range)
            attributedString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: label.font.pointSize), range: range)
            label.attributedText = attributedString
        } else {
            label.text = text
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        posterImageView.backgroundColor = .tdMain
        titleLabel.text = nil
        titleLabel.attributedText = nil
        commentLabel.text = nil
        commentLabel.attributedText = nil
        dateLabel.text = nil
        currentQuery = Strings.Global.empty.text
    }
}
