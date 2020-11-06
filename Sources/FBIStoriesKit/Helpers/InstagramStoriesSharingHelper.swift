import UIKit
import Foundation

public final class InstagramStoriesSharingHelper: FBIStoriesSharingHelper {

    public func canShare() -> Bool {
        UIApplication.shared.canOpenURL(shareUrl)
    }

    public func share(_ object: FBIStoriesObject, completion: @escaping (_ success: Bool) -> ()) {
        guard canShare() else {
            completion(false)
            return
        }

        let item = object.makePasteboardItem()

        DispatchQueue.main.async {
            let expirationDate = Date().addingTimeInterval(pasteboardItemsExpirationTime)
            let pasteboardOptions = [UIPasteboard.OptionsKey.expirationDate: expirationDate]

            UIPasteboard.general.setItems([item], options: pasteboardOptions)
            UIApplication.shared.open(shareUrl) { success in
                completion(success)
            }
        }
    }
}


extension FBIStoriesObject {
    fileprivate func makePasteboardItem() -> [String: Any] {
        var item: [String: Any] = [:]

        switch backgroundContent {
        case .image(let image):
            if let imageData = image.pngData() {
                item["com.instagram.sharedSticker.backgroundImage"] = imageData
            }
        case .imageData(let data):
            item["com.instagram.sharedSticker.backgroundImage"] = data
        case .video(let videoData):
            item["com.instagram.sharedSticker.backgroundVideo"] = videoData
        case .imageUrl(let imageUrl):
            if let imageData = try? Data(contentsOf: imageUrl) {
                item["com.instagram.sharedSticker.backgroundImage"] = imageData
            }
        case .videoUrl(let videoUrl):
            if let videoData = try? Data(contentsOf: videoUrl) {
                item["com.instagram.sharedSticker.backgroundVideo"] = videoData
            }
        default:
            break
        }

        if let topColorString = topColor?.hexString() {
            item["com.instagram.sharedSticker.backgroundTopColor"] = topColorString
        }

        if let bottomColorString = bottomColor?.hexString() {
            item["com.instagram.sharedSticker.backgroundBottomColor"] = bottomColorString
        }

        switch stickerImage {
        case .image(let image):
            if let data = image.pngData() {
                item["com.instagram.sharedSticker.stickerImage"] = data
            }
        case .imageData(let data):
            item["com.instagram.sharedSticker.stickerImage"] = data
        default:
            break
        }

        if let contentUrl = attributionUrl?.absoluteURL {
            item["com.instagram.sharedSticker.contentURL"] = contentUrl
        }

        return item
    }
}


private let shareUrl = URL(string: "instagram-stories://share")!
private let pasteboardItemsExpirationTime: TimeInterval = 50 * 6
