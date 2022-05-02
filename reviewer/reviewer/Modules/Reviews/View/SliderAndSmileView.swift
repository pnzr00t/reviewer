//
//  SliderAndSmileView.swift
//  reviewer
//
//  Created by Oleg Pustoshkin on 02.05.2022.
//

import Foundation
import SnapKit
import UIKit

class SliderAndSmileView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()

        titleLabel.text = ""
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.systemFont(ofSize: 18)

        return titleLabel
    }()

    private lazy var smileLabel: UILabel = {
        let smileLabel = UILabel()

        smileLabel.text = "😃";
        smileLabel.textColor = .black
        smileLabel.font = UIFont.systemFont(ofSize: 25)

        return smileLabel
    }()

    init() {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func commonInit() {
        backgroundColor = .white

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.topInset)
            make.leading.equalToSuperview().inset(Constants.leadingInset)
        }

        addSubview(smileLabel)
        smileLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.topInset)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}

fileprivate enum Constants {
    static let topInset: CGFloat = 0
    static let leadingInset: CGFloat = 0
    static let trailingInset: CGFloat = 0
    static let leadingAndTrailingInset: CGFloat = 8
    static let labelToTextOffset: CGFloat = 6
    
    static let avatarImageSize: CGSize = CGSize(width: 100, height: 100)
    static let avatarToTitleLabelTopOffset: CGFloat = 16
    
    static let stepperToLabelValueOffset: CGFloat = 16
    
    static let addImageSize: CGSize = CGSize(width: 24, height: 24)
    static let labelToAddImageOffset: CGFloat = 16
    static let bottomInsert: CGFloat = 50
}
