import Foundation

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String

    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         defaultBaseURL: URL,
         authURLString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }

    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: unsplashAccessKey,
                secretKey: unsplashSecretKey,
                redirectURI: unsplashRedirectURI,
                accessScope: unsplashAccessScope,
                defaultBaseURL: unsplashDefaultBaseURL,
                authURLString: unsplashAuthorizeURLString)
    }
}
