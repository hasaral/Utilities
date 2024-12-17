import Foundation

public struct UserManager {
    let userKey = "user-1"
    public init() {}
    
    public func save(key: String?) {
        //if let oldModel = retrive() {
            let model = UserKey(
                token: key)
            KeychainService().save(model, for: userKey)
        //}
    }
    
    public func retrive() -> String? {
        if let user: UserKey = KeychainService().retrive(for: userKey) {
            if user.token != nil {
                return user.token?.description
            }
        }
        return nil
    }
    
    public func delete() {
        KeychainService().delete(key: userKey)
    }
    
}

public struct UserKey: Codable {
    var token: String?
}

