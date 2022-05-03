//
//  DetailReviewsViewController.swift
//  reviewer
//
//  Created by Oleg Pustoshkin on 03.05.2022.
//

import Foundation
import Kingfisher
import RxSwift
import RxCocoa
import UIKit
import SnapKit

class DetailReviewsViewController: UIViewController {
    private let reviewInfo: ReviewModel
    private let savedReviewCompletion: () -> Void

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

    private lazy var tourQuestionLabel: UILabel = {
        let tourQuestionLabel = UILabel()

        tourQuestionLabel.text = "Что вам особенно понравилось в этом туре?"
        tourQuestionLabel.textColor = .black
        tourQuestionLabel.numberOfLines = 2
        tourQuestionLabel.font = UIFont.boldSystemFont(ofSize: 16)

        return tourQuestionLabel
    }()
    private lazy var tourReviewTextView: UITextView = {
        let tourReviewTextView = UITextView()

        tourReviewTextView.text = Constants.tourReviewPlaceholder
        tourReviewTextView.textColor = .lightGray
        tourReviewTextView.font = UIFont.boldSystemFont(ofSize: 16)
        tourReviewTextView.delegate = self
        
        return tourReviewTextView
    }()

    private lazy var enhancementQuestionLabel: UILabel = {
        let enhancementQuestionLabel = UILabel()

        enhancementQuestionLabel.text = "Как мы могли бы улучшить подачу информации?"
        enhancementQuestionLabel.textColor = .black
        enhancementQuestionLabel.numberOfLines = 2
        enhancementQuestionLabel.font = UIFont.boldSystemFont(ofSize: 16)

        return enhancementQuestionLabel
    }()
    private lazy var enhancementReviewTextView: UITextView = {
        let enhancementReviewTextView = UITextView()

        enhancementReviewTextView.text = Constants.enhancementReviewPlaceholder
        enhancementReviewTextView.textColor = .lightGray
        enhancementReviewTextView.font = UIFont.boldSystemFont(ofSize: 16)
        enhancementReviewTextView.delegate = self

        return enhancementReviewTextView
    }()

    private lazy var saveReviewButton: UIButton = {
        let saveReviewButton = UIButton()

        saveReviewButton.setTitle("Сохранить отзыв", for: .normal)
        saveReviewButton.setTitleColor(.white, for: .normal)
        saveReviewButton.backgroundColor = .systemBlue
        saveReviewButton.layer.cornerRadius = 8

        return saveReviewButton
    }()
    
    private lazy var skipButton: UIButton = {
        let skipButton = UIButton()

        skipButton.setTitle("Пропустить", for: .normal)
        skipButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        skipButton.setTitleColor(UIColor.gray, for: .normal)

        return skipButton
    }()

    init(reviewInfo: ReviewModel, savedReview: @escaping () -> Void) {
        self.reviewInfo = reviewInfo
        self.savedReviewCompletion = savedReview
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

        view.addSubview(avatarImage)
        avatarImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.topInset)
            make.leading.equalToSuperview().inset(Constants.leadingInset)
            make.size.equalTo(Constants.avatarImageSize)
        }

        view.addSubview(tourQuestionLabel)
        tourQuestionLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImage.snp.bottom).offset(Constants.avatarToTitleLabelTopOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }
        
        view.addSubview(tourReviewTextView)
        tourReviewTextView.snp.makeConstraints { make in
            make.top.equalTo(tourQuestionLabel.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
            make.height.equalTo(Constants.tourReviewTextViewHeight)
        }

        view.addSubview(enhancementQuestionLabel)
        enhancementQuestionLabel.snp.makeConstraints { make in
            make.top.equalTo(tourReviewTextView.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
        }

        view.addSubview(enhancementReviewTextView)
        enhancementReviewTextView.snp.makeConstraints { make in
            make.top.equalTo(enhancementQuestionLabel.snp.bottom).offset(Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
            make.height.equalTo(Constants.enhancementReviewTextViewHeight)
        }
        
        view.addSubview(skipButton)
        skipButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
        }

        view.addSubview(saveReviewButton)
        saveReviewButton.snp.makeConstraints { make in
            make.bottom.equalTo(skipButton.snp.top).offset(-Constants.defaultVerticalOffset)
            make.leading.trailing.equalToSuperview().inset(Constants.leadingAndTrailingInset)
            make.height.equalTo(Constants.saveReviewButtonHeight)
        }
    }

    private func setupBindings() {
        saveReviewButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                var tourReviewString = ""
                if self.tourReviewTextView.textColor != .lightGray {
                    tourReviewString = self.tourReviewTextView.text
                }

                var tourEnhancementString = ""
                if self.enhancementReviewTextView.textColor != .lightGray {
                    tourEnhancementString = self.enhancementReviewTextView.text
                }

                let reviewInfo = ReviewModel(
                    tourID: self.reviewInfo.tourID,
                    tourRating: self.reviewInfo.tourRating,
                    gidRating: self.reviewInfo.gidRating,
                    informationRating: self.reviewInfo.informationRating,
                    navigationRating: self.reviewInfo.navigationRating,
                    tourReviewString: tourReviewString,
                    tourEnhancementString: tourEnhancementString
                )

                self.postContent(reviewModel: reviewInfo)

                self.dismiss(animated: true)
                self.savedReviewCompletion()
            })
            .disposed(by: disposeBag)

        skipButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

                self.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

    private func postContent(reviewModel: ReviewModel) {
        // create the url with URL
        let url = URL(string: "https://webhook.site/c8f2041c-c57e-433f-853f-1ef739702903")!
        
        // create the session object
        let session = URLSession.shared
        
        // now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        // add headers for the request
        request.addValue("application/json", forHTTPHeaderField: "Content-Type") // change as per server requirements
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            // convert parameters to Data and assign dictionary to httpBody of request
            request.httpBody = try JSONEncoder().encode(reviewModel)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                return
            }
            
            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                print("Invalid Response received from the server")
                return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                print("nil Data received from the server")
                return
            }
            
            do {
                // create json object from data or use JSONDecoder to convert to Model stuct
                if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
                    print(jsonResponse)
                    // handle json response
                } else {
                    print("data maybe corrupted or in wrong format")
                    throw URLError(.badServerResponse)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        // perform the task
        task.resume()
    }
}

extension DetailReviewsViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView === tourReviewTextView {
            if (textView.text == Constants.tourReviewPlaceholder && textView.textColor == .lightGray)
            {
                textView.text = ""
                textView.textColor = .black
            }
            textView.becomeFirstResponder() //Optional
            return
        }

        if textView === enhancementReviewTextView {
            if (textView.text == Constants.enhancementReviewPlaceholder && textView.textColor == .lightGray)
            {
                textView.text = ""
                textView.textColor = .black
            }
            textView.becomeFirstResponder() //Optional
            return
        }
    }

    func textViewDidEndEditing(_ textView: UITextView)
    {
        if textView === tourReviewTextView {
            if (textView.text == "")
            {
                textView.text = Constants.tourReviewPlaceholder
                textView.textColor = .lightGray
            }

            textView.resignFirstResponder()
        }

        if textView === enhancementReviewTextView {
            if (textView.text == "")
            {
                textView.text = Constants.enhancementReviewPlaceholder
                textView.textColor = .lightGray
            }

            textView.resignFirstResponder()
        }
    }
}

fileprivate enum Constants {
    static let topInset: CGFloat = 30
    static let leadingInset: CGFloat = 8
    static let trailingInset: CGFloat = 8
    static let leadingAndTrailingInset: CGFloat = 8

    static let avatarImageSize: CGSize = CGSize(width: 100, height: 100)
    static let avatarToTitleLabelTopOffset: CGFloat = 16

    static let saveReviewButtonHeight: CGFloat = 44

    static let defaultVerticalOffset: CGFloat = 8

    static let tourReviewTextViewHeight: CGFloat = 100
    static let enhancementReviewTextViewHeight: CGFloat = 100

    static let bottomInset: CGFloat = 16
 
 
    static let tourReviewPlaceholder: String = "Напишите здесь, чем вам запомнился тур, посоветуете ли вы его друзьям и как удалось повеселиться..."
    static let enhancementReviewPlaceholder: String = "Напишите здесь, чем вам запомнился тур, посоветуете ли вы его друзьям и как удалось повеселиться..."
}
