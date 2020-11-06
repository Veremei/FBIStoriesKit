import UIKit

public struct FBIStoriesObject {
    public enum BackgroundContent {
        case image(UIImage)
        case imageData(Data)
        case video(Data)
        case imageUrl(URL)
        case videoUrl(URL)
    }

    public enum Sticker {
        case image(UIImage)
        case imageData(Data)
    }

    public let backgroundContent: Self.BackgroundContent?
    public let topColor: UIColor?
    public let bottomColor: UIColor?
    public let stickerImage: Sticker?
    public let attributionUrl: URL?

    public init(
        content: Self.BackgroundContent,
        topColor: UIColor?,
        bottomColor: UIColor?,
        stickerImage: Self.Sticker?,
        attributionUrl: URL?
    ) {
        self.backgroundContent = content
        self.topColor = topColor
        self.bottomColor = bottomColor
        self.stickerImage = stickerImage
        self.attributionUrl = attributionUrl
    }
}
