//
//  MessageCell.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 08.02.2022.
//

import UIKit

final class MessageCell: PreparableTableCell {

    private enum Constants {
        static let bubbleExtraSpacing: CGFloat = 80
        static let innerSpacing: CGFloat = 4
        static let contentPadding: CGFloat = 8
        static let innerPadding: CGFloat = 8
        static let statusIconWidth: CGFloat = 12
        static let spacing: CGFloat = 2
        static let timeFormat = DateTimeFormat.hhmm_Colon.make()
    }

    private let containerView = UIView().prepareForAutoLayout()
    private let messageLabel = UILabel().prepareForAutoLayout()
    private let statusContainerView = UIStackView().prepareForAutoLayout()
    private let timeLabel = UILabel().prepareForAutoLayout()
    private let statusIcon = UIImageView().prepareForAutoLayout()

    private var timeLabelTopConstraint: NSLayoutConstraint!
    private var timeLabelBottomConstraint: NSLayoutConstraint!
    private var messageLabelRightConstraintToTimeLabel: NSLayoutConstraint!
    private var messageLabelRightConstraintToContainerView: NSLayoutConstraint!

    private var viewModel: MessageCellViewModel?

    override func prepare(withViewModel viewModel: PreparableViewModel?) {
        guard let viewModel = viewModel as? MessageCellViewModel else { return }
        self.viewModel = viewModel

        prepareView()

        messageLabel.text = viewModel.model.text
        timeLabel.text = viewModel.model.sendingTime
        statusIcon.image = viewModel.model.deliveryStatus.icon

        if viewModel.model.direction == .outgoing {
            statusContainerView.addArrangedSubview(statusIcon)
        }
        statusContainerView.addArrangedSubview(timeLabel)
        activateConstraints()
    }

    private func prepareView() {
        contentView.addSubview(containerView)
        containerView.addSubview(messageLabel)
        containerView.addSubview(statusContainerView)
        prepareContainerView()
        prepareMessageLabel()
        prepareStatusView()
    }

    private func prepareContainerView() {
        let edges = UIEdgeInsets(top: Constants.contentPadding,
                                 left: Constants.contentPadding,
                                 bottom: Constants.contentPadding,
                                 right: Constants.contentPadding)
        var sides: [UIView.PinnedSide]
        var bottomCornersValue: CACornerMask
        if case .outgoing = viewModel?.model.direction {
            sides = [.right, .top, .bottom]
            bottomCornersValue = [.layerMinXMaxYCorner]
            containerView.leadingAnchor >= contentView.leadingAnchor + Constants.bubbleExtraSpacing
        } else {
            sides = [.left, .top, .bottom]
            bottomCornersValue = [.layerMaxXMaxYCorner]
            containerView.trailingAnchor <= contentView.trailingAnchor - Constants.bubbleExtraSpacing
        }
        containerView.pinToSuperview(sides, edges)

        containerView.layer.cornerRadius = 10
        let topCornersValue: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        containerView.layer.maskedCorners = bottomCornersValue.union(topCornersValue)
        containerView.backgroundColor = .messageBubbleColor
    }

    private func prepareMessageLabel() {
        messageLabel.topAnchor ~= containerView.topAnchor + Constants.innerPadding
        messageLabel.leadingAnchor ~= containerView.leadingAnchor + Constants.innerPadding
        messageLabelRightConstraintToContainerView = messageLabel.trailingAnchor ~= containerView.trailingAnchor - Constants.innerPadding
        messageLabel.numberOfLines = 0
        messageLabel.font = (viewModel?.layout ?? MessageCellLayout.default).messageFont
        messageLabel.textColor = UIColor.white
        messageLabel.backgroundColor = UIColor.clear
    }

    private func prepareStatusView() {
        statusContainerView.axis = .horizontal
        statusContainerView.spacing = Constants.spacing
        statusContainerView.alignment = .lastBaseline

        messageLabelRightConstraintToTimeLabel = messageLabel.trailingAnchor ~= statusContainerView.leadingAnchor - 2*Constants.innerSpacing
        messageLabelRightConstraintToTimeLabel.isActive = false
        statusContainerView.bottomAnchor ~= containerView.bottomAnchor - Constants.innerPadding
        statusContainerView.trailingAnchor ~= containerView.trailingAnchor - Constants.innerPadding
        timeLabelTopConstraint = statusContainerView.topAnchor ~= messageLabel.bottomAnchor + 2
        timeLabelBottomConstraint = statusContainerView.bottomAnchor ~= messageLabel.bottomAnchor
        timeLabelBottomConstraint.isActive = false

        timeLabel.font = (viewModel?.layout ?? MessageCellLayout.default).timeFont
        timeLabel.textColor = .lightGray
        timeLabel.textAlignment = .right

        statusIcon.widthAnchor ~= timeLabel.font.lineHeight
        statusIcon.heightAnchor ~= timeLabel.font.lineHeight
        statusIcon.tintColor = .lightGray
    }
    
    private func activateConstraints() {
        let messageFont = (viewModel?.layout ?? MessageCellLayout.default).messageFont
        let timeFont = (viewModel?.layout ?? MessageCellLayout.default).timeFont
        let text = viewModel?.model.text
        let time = viewModel?.model.sendingTime ?? Constants.timeFormat

        let deliveringStatusWidth: CGFloat = (viewModel?.model.direction ?? .incoming) == .outgoing ? timeFont.lineHeight + Constants.spacing : 0
        let timeLabelWidth = time.width(withConstrainedHeight: timeFont.lineHeight, font: timeFont)
        let messageLabelWidth = contentView.bounds.width - (Constants.bubbleExtraSpacing + Constants.contentPadding) - 2 * Constants.innerPadding - 2 * Constants.innerSpacing - timeLabelWidth - deliveringStatusWidth
        let messageLineHeight = messageFont.lineHeight
        guard let calculatedHeight = text?.height(withConstrainedWidth: messageLabelWidth, font: messageFont),
              let calculatedWidth = text?.width(withConstrainedHeight: messageLineHeight, font: messageFont) else { return }
        
        let isInOneLine = calculatedHeight > ceil(messageLineHeight) || calculatedWidth > messageLabelWidth
        timeLabelTopConstraint.isActive = isInOneLine
        timeLabelBottomConstraint.isActive = !isInOneLine
        messageLabelRightConstraintToTimeLabel.isActive = !isInOneLine
        messageLabelRightConstraintToContainerView.isActive = isInOneLine
    }
}
