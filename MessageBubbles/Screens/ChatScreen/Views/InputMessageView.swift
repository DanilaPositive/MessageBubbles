//
//  InputMessageView.swift
//  MessageBubbles
//
//  Created by Danila Matyushin on 08.02.2022.
//

import UIKit

@objc
protocol InputMessageViewDelegate: AnyObject {
    func tappedSendMessageButton(_ text: String)
}

class InputMessageView: UIView {

    private enum Constants {
        static let minTextViewHeight: CGFloat = 34
        static let buttonItemHeight: CGFloat = 44
        static let padding: CGFloat = 8
        static let buttonPadding: CGFloat = 3
        static let textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        static let borderWidth: CGFloat = 0.5
    }

    weak var delegate: InputMessageViewDelegate?

    var text: String? {
        get { textView.text }
        set {
            textView.text = newValue
            textViewDidChange(textView)
        }
    }

    private var textView = UITextView().prepareForAutoLayout()
    private var sendButton = UIButton().prepareForAutoLayout()

    private var textViewHeightConstraint: NSLayoutConstraint!
    private var rightStackViewWidthConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func prepareView() {
        backgroundColor = .messageBubbleColor
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: bounds.width, height: Constants.borderWidth)
        topBorder.backgroundColor = UIColor.lightGray.cgColor
        layer.addSublayer(topBorder)
        clipsToBounds = true

        addSubview(textView)
        addSubview(sendButton)
        prepareTextView()
        prepareSendButton()
    }
    
    private func prepareTextView() {
        textView.leadingAnchor ~= leadingAnchor + Constants.padding
        textView.bottomAnchor ~= bottomAnchor - Constants.padding
        textView.topAnchor ~= topAnchor + Constants.padding
        textViewHeightConstraint = textView.heightAnchor ~= Constants.minTextViewHeight

        textView.delegate = self
        textView.isScrollEnabled = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textContainerInset = Constants.textContainerInset
        textView.layer.cornerRadius = Constants.minTextViewHeight / 2
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = Constants.borderWidth
    }
    
    private func prepareSendButton() {
        sendButton.trailingAnchor ~= trailingAnchor - Constants.buttonPadding
        sendButton.bottomAnchor ~= bottomAnchor - Constants.buttonPadding
        sendButton.leadingAnchor ~= textView.trailingAnchor + Constants.buttonPadding
        sendButton.widthAnchor ~= Constants.buttonItemHeight
        sendButton.heightAnchor ~= Constants.buttonItemHeight

        sendButton.tintColor = .lightGray
        sendButton.setImage(UIImage(named: "icon_send"), for: .normal)
        sendButton.addTarget(self, action: #selector(secondButtonTapped(_:)), for: .touchUpInside)
    }

    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }

    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }

    @objc
    private func secondButtonTapped(_ sender: UIButton) {
        delegate?.tappedSendMessageButton(textView.text)
    }
}

extension InputMessageView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let startHeight = textView.frame.size.height
        var calculatedHeight = textView.sizeThatFits(textView.frame.size).height
        if startHeight != calculatedHeight {
            calculatedHeight = calculatedHeight < Constants.minTextViewHeight
                ? Constants.minTextViewHeight : calculatedHeight
            textViewHeightConstraint.constant = calculatedHeight
        }
    }
}
