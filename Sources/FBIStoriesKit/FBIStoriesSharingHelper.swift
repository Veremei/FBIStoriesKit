import Foundation

public protocol FBIStoriesSharingHelper {
    func canShare() -> Bool
    func share(_ object: FBIStoriesObject, completion: @escaping (_ success: Bool) -> ())
}
