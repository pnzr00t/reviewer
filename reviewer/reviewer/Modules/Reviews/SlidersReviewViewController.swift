//
//  SlidersReviewViewController.swift
//  reviewer
//
//  Created by Oleg Pustoshkin on 02.05.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit

class SlidersReviewViewController: UIViewController {
    private let disposeBag = DisposeBag()

    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView(image: UIImage(systemName: "face.smiling.fill"))
        avatarImage.layer.cornerRadius = Constants.avatarImageSize.width / 2
        return avatarImage
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()

        titleLabel.text = "Офигенно, вы дошли до конца!\nРасскажите, как вам?"
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.font = UIFont.boldSystemFont(ofSize: 21.0)

        return titleLabel
    }()

    private lazy var sliderAndSmileView: SliderAndSmileView = {
        let sliderAndSmileView = SliderAndSmileView()

        sliderAndSmileView.titleLabel.text = "Как вам тур в целом?"
        
        return sliderAndSmileView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
        setupBindings()
    }

    private func commonInit() {
        view.backgroundColor = .white

        view.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.topInset)
            make.leading.equalToSuperview().inset(Constants.leadingInset)
            make.size.equalTo(Constants.avatarImageSize)
        }

        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.bottom).offset(Constants.avatarToTitleLabelTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        view.addSubview(sliderAndSmileView)
        sliderAndSmileView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }
    }

    private func setupBindings() {
        /*addReviewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                let viewController = UIViewController()
                viewController.view.backgroundColor = .darkText

                self.present(viewController, animated: true, completion: { debugPrint(":DEBUG:", "Completion") })
            })
            .disposed(by: disposeBag)*/
    }
}

fileprivate enum Constants {
    static let topInset: CGFloat = 30
    static let leadingInset: CGFloat = 8
    static let trailingInset: CGFloat = 8
    static let leadingAndTrailingInset: CGFloat = 8
    static let labelToTextOffset: CGFloat = 6
    
    static let avatarImageSize: CGSize = CGSize(width: 100, height: 100)
    static let avatarToTitleLabelTopOffset: CGFloat = 16

    static let defaultVerticalOffset: CGFloat = 16
}
