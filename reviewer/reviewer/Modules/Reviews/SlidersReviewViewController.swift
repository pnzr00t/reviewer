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

    private lazy var tourRatingSliderAndSmileView: SliderAndSmileView = {
        let sliderAndSmileView = SliderAndSmileView()

        sliderAndSmileView.titleLabel.text = "Как вам тур в целом?"
        
        return sliderAndSmileView
    }()

    private lazy var gidRatingSliderAndSmileView: SliderAndSmileView = {
        let sliderAndSmileView = SliderAndSmileView()

        sliderAndSmileView.titleLabel.text = "Понравился гид?"
        
        return sliderAndSmileView
    }()

    private lazy var infoRatingSliderAndSmileView: SliderAndSmileView = {
        let sliderAndSmileView = SliderAndSmileView()

        sliderAndSmileView.titleLabel.text = "Как вам подача информации?"
        
        return sliderAndSmileView
    }()

    private lazy var navigationRatingSliderAndSmileView: SliderAndSmileView = {
        let sliderAndSmileView = SliderAndSmileView()

        sliderAndSmileView.titleLabel.text = "Удобная навигация между шагами?"
        
        return sliderAndSmileView
    }()

    private lazy var continueButton: UIButton = {
        let continueButton = UIButton()

        continueButton.setTitle("Далее", for: .normal)
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.backgroundColor = .systemBlue
        continueButton.layer.cornerRadius = 8

        return continueButton
    }()
    
    private lazy var skipButton: UIButton = {
        let skipButton = UIButton()

        skipButton.setTitle("Не хочу отвечать", for: .normal)
        skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        skipButton.setTitleColor(UIColor.gray, for: .normal)

        return skipButton
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

        view.addSubview(tourRatingSliderAndSmileView)
        tourRatingSliderAndSmileView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        view.addSubview(gidRatingSliderAndSmileView)
        gidRatingSliderAndSmileView.snp.makeConstraints { make in
            make.top.equalTo(tourRatingSliderAndSmileView.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        view.addSubview(infoRatingSliderAndSmileView)
        infoRatingSliderAndSmileView.snp.makeConstraints { make in
            make.top.equalTo(gidRatingSliderAndSmileView.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        view.addSubview(navigationRatingSliderAndSmileView)
        navigationRatingSliderAndSmileView.snp.makeConstraints { make in
            make.top.equalTo(infoRatingSliderAndSmileView.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        view.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(navigationRatingSliderAndSmileView.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
            make.height.equalTo(Constants.continueButtonHeight)
        }

        view.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.centerX.equalTo(continueButton.snp.centerX)
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
    
    static let avatarImageSize: CGSize = CGSize(width: 100, height: 100)
    static let avatarToTitleLabelTopOffset: CGFloat = 16
    
    static let continueButtonHeight: CGFloat = 44

    static let defaultVerticalOffset: CGFloat = 8
}
