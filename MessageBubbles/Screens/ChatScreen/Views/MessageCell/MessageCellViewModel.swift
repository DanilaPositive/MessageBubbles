//
//  MessageCellViewModel.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 09.02.2022.
//

import UIKit

struct MessageCellLayout {
    let messageFont: UIFont
    let timeFont: UIFont

    static var `default` = MessageCellLayout(messageFont: UIFont.systemFont(ofSize: 14),
                                             timeFont: UIFont.systemFont(ofSize: 10))
}

struct MessageCellViewModel: PreparableViewModel {
    var cellId: String { return MessageCell.className }
    let model: MessageData
    let layout: MessageCellLayout

    init(model: MessageData, layout: MessageCellLayout = .default) {
        self.model = model
        self.layout = layout
    }
}
