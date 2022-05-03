//
//  TourViewController.swift
//  reviewer
//
//  Created by Oleg Pustoshkin on 02.05.2022.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit
import SnapKit

class TourViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private lazy var addReviewButton: UIButton = {
        let addReviewButton = UIButton()

        addReviewButton.setTitle("Оставить отзыв", for: .normal)
        addReviewButton.setTitleColor(UIColor.black, for: .normal)
        addReviewButton.layer.cornerRadius = 8
        addReviewButton.backgroundColor = .blue

        return addReviewButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commonInit()
        setupBindings()
    }

    private func commonInit() {
        view.backgroundColor = .white
        view.addSubview(addReviewButton)
        addReviewButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(Constants.makeReviewButtonHeight)
            $0.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }
    }

    private func setupBindings() {
        addReviewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                let viewController = SlidersRatingReviewViewController(tourID: UUID())

                self.present(viewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
}

fileprivate enum Constants {
    static let leadingAndTrailingInset: CGFloat = 8
    
    static let makeReviewButtonHeight: CGFloat = 44
}
