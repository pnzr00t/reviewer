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
        }
    }

    private func setupBindings() {
        addReviewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                let viewController = UIViewController()
                viewController.view.backgroundColor = .darkText

                self.present(viewController, animated: true, completion: { debugPrint(":DEBUG:", "Completion") })
            })
            .disposed(by: disposeBag)
    }
}
