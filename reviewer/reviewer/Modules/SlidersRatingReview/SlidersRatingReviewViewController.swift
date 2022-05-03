//
//  SlidersReviewViewController.swift
//  reviewer
//
//  Created by Oleg Pustoshkin on 02.05.2022.
//

import Foundation
import Kingfisher
import RxSwift
import RxCocoa
import UIKit
import SnapKit

class SlidersRatingReviewViewController: UIViewController {
    private let tourID: UUID

    private let disposeBag = DisposeBag()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        return scrollView
    }()
    private lazy var contentView: UIView = {
        let contentView = UIView()

        return contentView
    }()

    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView(image: UIImage(systemName: "face.smiling.fill"))
        
        let url = URL(string: "https://app.wegotrip.com/media/users/1/path32.png")
        let processor = RoundCornerImageProcessor(cornerRadius: Constants.avatarImageSize.width / 2)

        avatarImage.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "face.smiling.fill"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )

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

    init(tourID: UUID) {
        self.tourID = tourID
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
        setupBindings()
    }

    private func commonInit() {
        view.backgroundColor = .white

        view.addSubview(scrollView)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
        // ContentWidth == SuperViewWidth
        scrollView.contentLayoutGuide.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
        }

        contentView.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.topInset)
            make.leading.equalToSuperview().inset(Constants.leadingInset)
            make.size.equalTo(Constants.avatarImageSize)
        }

        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.bottom).offset(Constants.avatarToTitleLabelTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        contentView.addSubview(tourRatingSliderAndSmileView)
        tourRatingSliderAndSmileView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        contentView.addSubview(gidRatingSliderAndSmileView)
        gidRatingSliderAndSmileView.snp.makeConstraints { make in
            make.top.equalTo(tourRatingSliderAndSmileView.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        contentView.addSubview(infoRatingSliderAndSmileView)
        infoRatingSliderAndSmileView.snp.makeConstraints { make in
            make.top.equalTo(gidRatingSliderAndSmileView.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        contentView.addSubview(navigationRatingSliderAndSmileView)
        navigationRatingSliderAndSmileView.snp.makeConstraints { make in
            make.top.equalTo(infoRatingSliderAndSmileView.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        contentView.addSubview(continueButton)
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(navigationRatingSliderAndSmileView.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
            make.height.equalTo(Constants.continueButtonHeight)
        }

        contentView.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.top.equalTo(continueButton.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.centerX.equalTo(continueButton.snp.centerX)
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
        }
    }

    private func setupBindings() {
        continueButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                let reviewInfo = ReviewModel(
                    tourID: self.tourID,
                    tourRating: self.tourRatingSliderAndSmileView.stepperValue,
                    gidRating: self.gidRatingSliderAndSmileView.stepperValue,
                    informationRating: self.infoRatingSliderAndSmileView.stepperValue,
                    navigationRating: self.navigationRatingSliderAndSmileView.stepperValue,
                    tourReviewString: "",
                    tourEnhancementString: ""
                )

                // savedReviewCompletion Сильно не лучшее решение, но vc.modalPresentationStyle = .overCurrentContext
                // Не дает закрыть следующий экран по свайпу вниз, а реализовывать закрытие по свайку вниз с GestureRecoginzer
                // Нет времени т.к. проект должен быть сдан до среды
                let detailReviewsViewController = DetailReviewsViewController(reviewInfo: reviewInfo, savedReview: { [weak self] in self?.dismiss(animated: true) })

                self.present(detailReviewsViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                let reviewInfo = ReviewModel(
                    tourID: self.tourID,
                    tourRating: nil,
                    gidRating: nil,
                    informationRating: nil,
                    navigationRating: nil,
                    tourReviewString: "",
                    tourEnhancementString: ""
                )

                let detailReviewsViewController = DetailReviewsViewController(reviewInfo: reviewInfo, savedReview: { [weak self] in self?.dismiss(animated: true) })

                self.present(detailReviewsViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
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

    static let bottomInset: CGFloat = 16
}
