// Moves/resizes the focused window of the frontmost app.
// Build: swiftc -O -target arm64-apple-macos12 window.swift -o window
// Usage: window <left|right|maximize|almost-maximize|next-display|prev-display> [--dry-run]
import AppKit

// Visible frames of all screens in Accessibility coordinates (top-left origin of the primary screen),
// sorted left to right.
func screens() -> [CGRect] {
  let all = NSScreen.screens
  guard let primary = all.first else { return [] }
  let primaryHeight = primary.frame.height
  let menuBarHeight = primary.frame.maxY - primary.visibleFrame.maxY
  // Outside a GUI app, secondary screens report a visibleFrame that ignores their menu bar,
  // and NSScreen.screensHaveSeparateSpaces is always false, so read the pref directly.
  let separateSpaces = !(UserDefaults(suiteName: "com.apple.spaces")?.bool(forKey: "spans-displays") ?? false)

  return all.map { screen in
    let f = screen.frame
    let vf = screen.visibleFrame
    var top = vf.maxY
    if separateSpaces && f.maxY - top < menuBarHeight {
      top = f.maxY - menuBarHeight
    }
    return CGRect(x: vf.minX, y: primaryHeight - top, width: vf.width, height: top - vf.minY)
  }.sorted { ($0.minX, $0.minY) < ($1.minX, $1.minY) }
}

func overlap(_ a: CGRect, _ b: CGRect) -> CGFloat {
  let i = a.intersection(b)
  return i.isNull ? 0 : i.width * i.height
}

func targetFrame(_ action: String, _ frame: CGRect, _ screens: [CGRect]) -> CGRect? {
  guard !screens.isEmpty else { return nil }
  var index = 0
  for (i, s) in screens.enumerated() where overlap(frame, s) > overlap(frame, screens[index]) {
    index = i
  }
  let s = screens[index]

  switch action {
  case "left":
    return CGRect(x: s.minX, y: s.minY, width: s.width / 2, height: s.height)
  case "right":
    return CGRect(x: s.midX, y: s.minY, width: s.width / 2, height: s.height)
  case "maximize":
    return s
  case "almost-maximize":
    return s.insetBy(dx: s.width * 0.15, dy: s.height * 0.15)
  case "next-display", "prev-display":
    let step = action == "next-display" ? 1 : -1
    let t = screens[(index + step + screens.count) % screens.count]
    // Keep the window's relative position and size on the new display.
    let w = min(t.width, frame.width / s.width * t.width)
    let h = min(t.height, frame.height / s.height * t.height)
    let x = min(t.maxX - w, max(t.minX, t.minX + (frame.minX - s.minX) / s.width * t.width))
    let y = min(t.maxY - h, max(t.minY, t.minY + (frame.minY - s.minY) / s.height * t.height))
    return CGRect(x: x, y: y, width: w, height: h)
  default:
    return nil
  }
}

func attribute(_ element: AXUIElement, _ name: String) -> CFTypeRef? {
  var value: CFTypeRef?
  return AXUIElementCopyAttributeValue(element, name as CFString, &value) == .success ? value : nil
}

func frame(of window: AXUIElement) -> CGRect? {
  guard let posValue = attribute(window, kAXPositionAttribute),
        let sizeValue = attribute(window, kAXSizeAttribute) else { return nil }
  var pos = CGPoint.zero
  var size = CGSize.zero
  AXValueGetValue(posValue as! AXValue, .cgPoint, &pos)
  AXValueGetValue(sizeValue as! AXValue, .cgSize, &size)
  return CGRect(origin: pos, size: size)
}

func setFrame(_ window: AXUIElement, _ frame: CGRect) {
  var pos = frame.origin
  var size = frame.size
  let posValue = AXValueCreate(.cgPoint, &pos)!
  let sizeValue = AXValueCreate(.cgSize, &size)!
  // Position, size, position again: some apps clamp size against the old position.
  AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, posValue)
  AXUIElementSetAttributeValue(window, kAXSizeAttribute as CFString, sizeValue)
  AXUIElementSetAttributeValue(window, kAXPositionAttribute as CFString, posValue)
}

let args = CommandLine.arguments.dropFirst()
guard let action = args.first else {
  fputs("usage: window <left|right|maximize|almost-maximize|next-display|prev-display> [--dry-run]\n", stderr)
  exit(2)
}
let dryRun = args.contains("--dry-run")

guard let pid = NSWorkspace.shared.frontmostApplication?.processIdentifier else { exit(0) }
let app = AXUIElementCreateApplication(pid)
var windowRef: CFTypeRef?
let result = AXUIElementCopyAttributeValue(app, kAXFocusedWindowAttribute as CFString, &windowRef)
// Only check trust on failure: AXIsProcessTrustedWithOptions costs ~20 ms on every launch.
if result == .apiDisabled {
  let promptOption = kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String
  AXIsProcessTrustedWithOptions([promptOption: true] as CFDictionary)
  fputs("window: Accessibility permission required\n", stderr)
  exit(1)
}
guard result == .success, let windowRef else { exit(0) }
let window = windowRef as! AXUIElement
guard let current = frame(of: window) else { exit(0) }

guard let target = targetFrame(action, current, screens()).map({ $0.integral }) else {
  fputs("window: unknown action \(action)\n", stderr)
  exit(2)
}

if dryRun {
  print("from \(current) to \(target)")
  exit(0)
}

// Apps with enhanced UI enabled (Chrome, Electron, ...) animate each change; turn it off while resizing.
let enhancedUI = "AXEnhancedUserInterface" as CFString
let hadEnhancedUI = attribute(app, "AXEnhancedUserInterface") as? Bool ?? false
if hadEnhancedUI { AXUIElementSetAttributeValue(app, enhancedUI, kCFBooleanFalse) }
setFrame(window, target)
if hadEnhancedUI { AXUIElementSetAttributeValue(app, enhancedUI, kCFBooleanTrue) }
