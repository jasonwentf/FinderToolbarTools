import AppKit

guard CommandLine.arguments.count == 4 else {
    fputs("usage: render-icon <search|up> <light|dark> <output.png>\n", stderr)
    exit(2)
}

let kind = CommandLine.arguments[1]
let appearance = CommandLine.arguments[2]
let output = CommandLine.arguments[3]
guard ["search", "up"].contains(kind), ["light", "dark"].contains(appearance) else {
    exit(2)
}

let bitmap = NSBitmapImageRep(
    bitmapDataPlanes: nil, pixelsWide: 1024, pixelsHigh: 1024,
    bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
    colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0
)!
bitmap.size = NSSize(width: 1024, height: 1024)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
NSGraphicsContext.current?.imageInterpolation = .high

let ink = appearance == "light" ? NSColor.black : NSColor.white
let paper = appearance == "light" ? NSColor.white : NSColor.black
let background = NSBezierPath(roundedRect: NSRect(x: 72, y: 72, width: 880, height: 880), xRadius: 205, yRadius: 205)
paper.setFill()
background.fill()

ink.setStroke()
if kind == "search" {
    let ring = NSBezierPath(ovalIn: NSRect(x: 247, y: 401, width: 376, height: 376))
    ring.lineWidth = 82
    ring.stroke()
    let handle = NSBezierPath()
    handle.move(to: NSPoint(x: 578, y: 446))
    handle.line(to: NSPoint(x: 744, y: 280))
    handle.lineWidth = 82
    handle.lineCapStyle = .round
    handle.stroke()
} else {
    let shaft = NSBezierPath()
    shaft.move(to: NSPoint(x: 512, y: 288))
    shaft.line(to: NSPoint(x: 512, y: 695))
    shaft.lineWidth = 82
    shaft.lineCapStyle = .round
    shaft.stroke()
    let chevron = NSBezierPath()
    chevron.move(to: NSPoint(x: 300, y: 512))
    chevron.line(to: NSPoint(x: 512, y: 724))
    chevron.line(to: NSPoint(x: 724, y: 512))
    chevron.lineWidth = 82
    chevron.lineCapStyle = .round
    chevron.lineJoinStyle = .round
    chevron.stroke()
}

NSGraphicsContext.restoreGraphicsState()
guard let data = bitmap.representation(using: .png, properties: [:]) else { exit(1) }
try data.write(to: URL(fileURLWithPath: output))
