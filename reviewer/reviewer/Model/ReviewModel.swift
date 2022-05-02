//
//  ReviewModel.swift
//  reviewer
//
//  Created by Oleg Pustoshkin on 02.05.2022.
//

import Foundation

struct ReviewModel: Codable {
    let tourID: UUID

    let tourGrade: Int?
    let gitGrade: Int?
    let informationGrade: Int?
    let navigationGrade: Int?

    let tourReviewString: String
    let tourEnhancementString: String
}
