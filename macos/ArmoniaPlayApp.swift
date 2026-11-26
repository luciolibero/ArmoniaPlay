import Cocoa
import WebKit

final class AppDelegate: NSObject, NSApplicationDelegate, WKUIDelegate, WKNavigationDelegate {
    private var window: NSWindow!
    private var webView: WKWebView!

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.regular)
        setupMenuBar()

        let contentRect = NSRect(x: 0, y: 0, width: 1280, height: 860)
        window = NSWindow(
            contentRect: contentRect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "ArmoniaPlay — Lucio Ardito"
        window.minSize = NSSize(width: 900, height: 620)
        window.center()

        let config = WKWebViewConfiguration()
        config.mediaTypesRequiringUserActionForPlayback = []
        config.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")

        webView = WKWebView(frame: contentRect, configuration: config)
        webView.autoresizingMask = [.width, .height]
        webView.uiDelegate = self
        webView.navigationDelegate = self

        window.contentView = webView
        window.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        loadBundledApp()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    private var isEnglish: Bool {
        return Locale.preferredLanguages.first?.lowercased().hasPrefix("en") == true
    }

    private func loadBundledApp() {
        if let htmlURL = Bundle.main.url(forResource: "ArmoniaPlay-standalone", withExtension: "html") {
            let resourcesDir = htmlURL.deletingLastPathComponent()
            webView.loadFileURL(htmlURL, allowingReadAccessTo: resourcesDir)
        } else {
            let fallback = isEnglish ? """
            <!DOCTYPE html><html lang="en"><body style="font-family:-apple-system;padding:40px;">
            <h2>ArmoniaPlay — Lucio Ardito</h2>
            <p>File ArmoniaPlay-standalone.html not found in the Resources bundle.</p>
            </body></html>
            """ : """
            <!DOCTYPE html><html lang="it"><body style="font-family:-apple-system;padding:40px;">
            <h2>ArmoniaPlay — Lucio Ardito</h2>
            <p>File ArmoniaPlay-standalone.html non trovato nel bundle Resources.</p>
            </body></html>
            """
            webView.loadHTMLString(fallback, baseURL: nil)
        }
    }

    private func setupMenuBar() {
        let en = isEnglish
        let mainMenu = NSMenu()

        // Menu Applicazione / App Menu
        let appMenuItem = NSMenuItem()
        mainMenu.addItem(appMenuItem)
        let appMenu = NSMenu(title: "ArmoniaPlay")
        appMenu.addItem(withTitle: en ? "About ArmoniaPlay" : "Informazioni su ArmoniaPlay", action: #selector(showAbout), keyEquivalent: "")
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: en ? "Hide ArmoniaPlay" : "Nascondi ArmoniaPlay", action: #selector(NSApplication.hide(_:)), keyEquivalent: "h")
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: en ? "Quit ArmoniaPlay" : "Esci da ArmoniaPlay", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
        appMenuItem.submenu = appMenu

        // Menu Modifica / Edit Menu (per copia/incolla nei campi ricerca e tag)
        let editMenuItem = NSMenuItem()
        mainMenu.addItem(editMenuItem)
        let editMenu = NSMenu(title: en ? "Edit" : "Modifica")
        editMenu.addItem(withTitle: en ? "Undo" : "Annulla", action: Selector(("undo:")), keyEquivalent: "z")
        editMenu.addItem(withTitle: en ? "Redo" : "Ripristina", action: Selector(("redo:")), keyEquivalent: "Z")
        editMenu.addItem(NSMenuItem.separator())
        editMenu.addItem(withTitle: en ? "Cut" : "Taglia", action: #selector(NSText.cut(_:)), keyEquivalent: "x")
        editMenu.addItem(withTitle: en ? "Copy" : "Copia", action: #selector(NSText.copy(_:)), keyEquivalent: "c")
        editMenu.addItem(withTitle: en ? "Paste" : "Incolla", action: #selector(NSText.paste(_:)), keyEquivalent: "v")
        editMenu.addItem(withTitle: en ? "Select All" : "Seleziona tutto", action: #selector(NSText.selectAll(_:)), keyEquivalent: "a")
        editMenuItem.submenu = editMenu

        // Menu Finestra / Window Menu
        let winMenuItem = NSMenuItem()
        mainMenu.addItem(winMenuItem)
        let winMenu = NSMenu(title: en ? "Window" : "Finestra")
        winMenu.addItem(withTitle: en ? "Minimize" : "Riduci a icona", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
        winMenu.addItem(withTitle: en ? "Zoom" : "Ridimensiona", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: "")
        winMenuItem.submenu = winMenu

        NSApp.mainMenu = mainMenu
    }

    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "ArmoniaPlay — Lucio Ardito"
        alert.informativeText = isEnglish
            ? "100% offline local music player (Italian / English).\nRules: No-Repeat, M/F Voice Alternation, Camelot Harmony, BPM/Energy, and Artist Separation."
            : "Player musicale locale 100% offline (Italiano / Inglese).\nRegole: No-Repeat, Alternanza voci M/F, Armonia Camelot, BPM/Energia e Separazione Artista."
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }

    // Supporto nativo per <input type="file"> e <input webkitdirectory> (file audio e cartelle locali)
    func webView(
        _ webView: WKWebView,
        runOpenPanelWith parameters: WKOpenPanelParameters,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping ([URL]?) -> Void
    ) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = parameters.allowsMultipleSelection
        panel.canChooseDirectories = parameters.allowsDirectories
        panel.canChooseFiles = !parameters.allowsDirectories
        panel.resolvesAliases = true

        panel.beginSheetModal(for: window) { response in
            if response == .OK {
                completionHandler(panel.urls)
            } else {
                completionHandler(nil)
            }
        }
    }

    // Apri link esterni (es. donazione PayPal con target="_blank") nel browser predefinito di macOS
    func webView(
        _ webView: WKWebView,
        createWebViewWith configuration: WKWebViewConfiguration,
        for navigationAction: WKNavigationAction,
        windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
        if let url = navigationAction.request.url,
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https" {
            NSWorkspace.shared.open(url)
        }
        return nil
    }

    // Supporto download (.m3u e .json) su macOS 11.3+ e apertura link esterni nel browser
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if #available(macOS 11.3, *) {
            if navigationAction.shouldPerformDownload {
                decisionHandler(.download)
                return
            }
        }
        if let url = navigationAction.request.url,
           let scheme = url.scheme?.lowercased(),
           scheme == "http" || scheme == "https" {
            NSWorkspace.shared.open(url)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    @available(macOS 11.3, *)
    func webView(_ webView: WKWebView, navigationAction: WKNavigationAction, didBecome download: WKDownload) {
        download.delegate = self
    }
}

@available(macOS 11.3, *)
extension AppDelegate: WKDownloadDelegate {
    func download(
        _ download: WKDownload,
        decideDestinationUsing response: URLResponse,
        suggestedFilename: String,
        completionHandler: @escaping (URL?) -> Void
    ) {
        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = suggestedFilename
        savePanel.canCreateDirectories = true
        savePanel.beginSheetModal(for: window) { result in
            if result == .OK {
                completionHandler(savePanel.url)
            } else {
                completionHandler(nil)
            }
        }
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
