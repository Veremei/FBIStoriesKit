import Foundation

public protocol YPFBIStoriesSharingHelper {
    func canShare() -> Bool
    func share(_ object: YPFBIStoriesObject, completion: @escaping (_ success: Bool) -> ())
}
