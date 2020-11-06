import UIKit
import Foundation

final class YPFacebookStoriesSharingHelper: YPFBIStoriesSharingHelper {
    private let facebookAppId: String

    init(facebookAppId: String) {
        self.facebookAppId = facebookAppId
    }

    func canShare() -> Bool {
        UIApplication.shared.canOpenURL(shareUrl)
    }

    func share(_ object: YPFBIStoriesObject, completion: @escaping (_ success: Bool) -> ()) {
        guard canShare() else {
            completion(false)
            return
        }

        let appId = facebookAppId

        var item = object.makePasteboardItem()
        item["com.facebook.sharedSticker.appID"] = appId

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


extension YPFBIStoriesObject {
    fileprivate func makePasteboardItem() -> [String: Any] {
        var item: [String: Any] = [:]

        switch backgroundContent {
        case .image(let image):
            if let imageData = image.pngData() {
                item["com.facebook.sharedSticker.backgroundImage"] = imageData
            }
        case .imageData(let data):
            item["com.facebook.sharedSticker.backgroundImage"] = data
        case .video(let videoData):
            item["com.facebook.sharedSticker.backgroundVideo"] = videoData
        case .imageUrl(let imageUrl):
            if let imageData = try? Data(contentsOf: imageUrl) {
                item["com.facebook.sharedSticker.backgroundImage"] = imageData
            }
        case .videoUrl(let videoUrl):
            if let videoData = try? Data(contentsOf: videoUrl) {
                item["com.facebook.sharedSticker.backgroundVideo"] = videoData
            }
        default:
            break
        }

        if let topColorString = topColor?.hexString() {
            item["com.facebook.sharedSticker.backgroundTopColor"] = topColorString
        }

        if let bottomColorString = bottomColor?.hexString() {
            item["com.facebook.sharedSticker.backgroundBottomColor"] = bottomColorString
        }

        switch stickerImage {
        case .image(let image):
            if let data = image.pngData() {
                item["com.facebook.sharedSticker.stickerImage"] = data
            }
        case .imageData(let data):
            item["com.facebook.sharedSticker.stickerImage"] = data
        default:
            break
        }

        if let contentUrl = attributionUrl?.absoluteURL {
            item["com.facebook.sharedSticker.contentURL"] = contentUrl
        }

        return item
    }
}


private let shareUrl = URL(string: "facebook-stories://share")!
private let pasteboardItemsExpirationTime: TimeInterval = 50 * 6
