import UIKit
import Artsy_UILabels
import Artsy_UIFonts
import Then

private typealias PrivateFunctions = LotListCollectionViewCell
extension PrivateFunctions {

    func setup() {
        // Necessary setup
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.alignToView(self)

        // Add and arrange imageView.
        contentView.addSubview(imageView)
        imageView.constrainWidth("60", height: "60")
        imageView.alignTop("10", bottom: "-10", toView: contentView)
        imageView.alignLeadingEdgeWithView(contentView, predicate: "20")

        // Now add, arrange, and configure the labelContainerView
        contentView.addSubview(labelContainerView)
        [lotNumberLabel, artistsNamesLabel, currentAskingPriceLabel].forEach { label in
            // Add them and pin their leading/trailing edges
            labelContainerView.addSubview(label)
            label.alignLeading("0", trailing: "0", toView: labelContainerView)
        }

        // We need to stack them a bit funny, because the currentAskingPriceLabel may be removed from the hierarchy later
        // So the layout needs to work with or without it.
        lotNumberLabel.alignTopEdgeWithView(labelContainerView, predicate: "0")
        artistsNamesLabel.alignAttribute(.Top, toAttribute: .Bottom, ofView: lotNumberLabel, predicate: "5")
        artistsNamesLabel.alignBottomEdgeWithView(labelContainerView, predicate: "<= 0")
        artistsNamesLabel.constrainBottomSpaceToView(currentAskingPriceLabel, predicate: "-2")
        currentAskingPriceLabel.alignBottomEdgeWithView(labelContainerView, predicate: "0")

        // Positions the label container.
        labelContainerView.constrainLeadingSpaceToView(imageView, predicate: "10")
        labelContainerView.alignTrailingEdgeWithView(contentView, predicate: "<= -10")
        labelContainerView.constrainHeight("<= 60")
        labelContainerView.alignCenterYWithView(imageView, predicate: "0")
    }

    func setLotState(lotState: LotState) {
        let contentViewAlpha: CGFloat
        let color: UIColor
        let includeCurrentPrice: Bool

        switch lotState {
        case .ClosedLot:
            contentViewAlpha = 0.5
            color = .blackColor()
            includeCurrentPrice = false
        case .LiveLot:
            contentViewAlpha = 1
            color = .whiteColor()
            includeCurrentPrice = true
        case .UpcomingLot:
            contentViewAlpha = 1
            color = .blackColor()
            includeCurrentPrice = false
        }

        if includeCurrentPrice {
            labelContainerView.addSubview(currentAskingPriceLabel)

            // Artists' names are restricted to one line.
            artistsNamesLabel.numberOfLines = 1
            artistsNamesLabel.lineBreakMode = .ByTruncatingTail

        } else {
            currentAskingPriceLabel.removeFromSuperview()

            // Artists' names are allowed to expand.
            artistsNamesLabel.numberOfLines = 0
            artistsNamesLabel.lineBreakMode = .ByWordWrapping
        }

        contentView.alpha = contentViewAlpha
        [lotNumberLabel, artistsNamesLabel, currentAskingPriceLabel].forEach { $0.textColor = color }

        contentView.setNeedsLayout()
    }
}

private typealias ClassFunctions = LotListCollectionViewCell
extension ClassFunctions {
    class func _lotNumberLabel() -> UILabel {
        return ARSansSerifLabel().then {
            $0.font = UIFont.sansSerifFontWithSize(12)
            $0.numberOfLines = 1
            $0.backgroundColor = .clearColor()
        }
    }

    class func _artistNamesLabel() -> UILabel {
        return ARSerifLabel().then {
            $0.font = UIFont.serifFontWithSize(14)
            $0.backgroundColor = .clearColor()
        }
    }

    class func _currentAskingPriceLabel() -> UILabel {
        return ARSansSerifLabel().then {
            $0.font = UIFont.sansSerifFontWithSize(16)
            $0.backgroundColor = .clearColor()
        }
    }

    class func _labelContainerView() -> UIView {
        // Container needs a reasonable-ish size when we add the artistsNamesLabel so that its preferredMaxLayoutWidth gets set to something non-zero.
        return UIView(frame: CGRect(origin: CGPoint.zero, size: UIScreen.mainScreen().bounds.size)).then {
            $0.translatesAutoresizingMaskIntoConstraints = false
            
        }
    }
}
