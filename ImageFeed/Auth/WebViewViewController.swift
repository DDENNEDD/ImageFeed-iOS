import WebKit
import UIKit

private struct APIConstants {
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let code = "code"
}

final class WebViewViewController: UIViewController {
    @IBOutlet private var webView: WKWebView!

    weak var delegate: WebViewViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadWebView()
    }

    @IBAction func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let code = code(from: navigationAction) {
                delegate?.webViewViewController(self, didAuthenticateWithCode: code)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    func loadWebView() {
        var urlComponents = URLComponents(string: APIConstants.UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: APIConstants.code),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

private func code(from navigationAction: WKNavigationAction) -> String? {
    if
        let url = navigationAction.request.url,
        let urlComponents = URLComponents(string: url.absoluteString),
        urlComponents.path == "/oauth/authorize/native",
        let items = urlComponents.queryItems,
        let codeItem = items.first(where: { $0.name == "code" }) {
        return codeItem.value
    } else {
        return nil
    }
}
