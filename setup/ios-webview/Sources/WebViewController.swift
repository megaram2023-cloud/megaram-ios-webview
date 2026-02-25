import UIKit
import WebKit
import UniformTypeIdentifiers

final class WebViewController: UIViewController {
    private var webView: WKWebView!
    private let refreshControl = UIRefreshControl()
    private var filePickerCompletion: (([URL]?) -> Void)?

    private var startURLString: String {
        (Bundle.main.object(forInfoDictionaryKey: "StartURL") as? String)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            ?? "https://proctological-caleb-seminiferous.ngrok-free.dev/ticket.html"
    }

    private var allowedHost: String? {
        URL(string: startURLString)?.host?.lowercased()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Incidencias"
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = true
        config.websiteDataStore = .default()

        webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.uiDelegate = self

        let settings = webView.configuration.preferences
        settings.javaScriptCanOpenWindowsAutomatically = true

        view.addSubview(webView)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        refreshControl.addTarget(self, action: #selector(reloadPage), for: .valueChanged)
        webView.scrollView.refreshControl = refreshControl

        if let url = URL(string: startURLString) {
            webView.load(URLRequest(url: url))
        }
    }

    @objc
    private func reloadPage() {
        webView.reload()
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        refreshControl.endRefreshing()
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }

        let scheme = (url.scheme ?? "").lowercased()
        if scheme == "http" || scheme == "https" {
            if let allowed = allowedHost, let host = url.host?.lowercased(), host != allowed {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
            return
        }

        UIApplication.shared.open(url)
        decisionHandler(.cancel)
    }
}

extension WebViewController: WKUIDelegate, UIDocumentPickerDelegate {
    @available(iOS 18.4, *)
    func webView(
        _ webView: WKWebView,
        runOpenPanelWith parameters: WKOpenPanelParameters,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping ([URL]?) -> Void
    ) {
        filePickerCompletion = completionHandler
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.item], asCopy: true)
        picker.allowsMultipleSelection = parameters.allowsMultipleSelection
        picker.delegate = self
        present(picker, animated: true)
    }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        filePickerCompletion?([])
        filePickerCompletion = nil
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        filePickerCompletion?(urls)
        filePickerCompletion = nil
    }
}
