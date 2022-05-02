//
//  ReviewModel.swift
//  reviewer
//
//  Created by Oleg Pustoshkin on 02.05.2022.
//

import Foundation

struct ReviewModel: Codable {
    let tourID: UUID

    let tourRating: Int?
    let gidRating: Int?
    let informationRating: Int?
    let navigationRating: Int?

    let tourReviewString: String
    let tourEnhancementString: String
}
