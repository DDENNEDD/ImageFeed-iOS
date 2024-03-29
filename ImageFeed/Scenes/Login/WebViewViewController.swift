import UIKit
import WebKit

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {

    private var estimatedProgressObservation: NSKeyValueObservation?
    var presenter: WebViewPresenterProtocol?
    weak var delegate: WebViewViewControllerDelegate?

    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!

    override func viewDidLoad() {
           super.viewDidLoad()
           configureWebView()
           presenter?.viewDidLoad()
       }

       private func configureWebView() {
           webView.navigationDelegate = self
           webView.accessibilityIdentifier = "UnsplashWebView"
           estimatedProgressObservation = webView.observe(\.estimatedProgress, options: []) { [weak self] _, _ in
               self?.handleEstimatedProgressUpdate()
           }
       }

    private func handleEstimatedProgressUpdate() {
           presenter?.didUpdateProgressValue(webView.estimatedProgress)
       }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }

    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }

    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }

    static func clean() {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
                                                      completionHandler: { records in
            records.forEach({ record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            })
        })
    }

    func load(request: URLRequest) {
        webView.load(request)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url {
            return presenter?.code(from: url)
        } else {
            return nil
        }
    }
}
