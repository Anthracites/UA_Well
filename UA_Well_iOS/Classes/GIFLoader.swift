import UIKit
import ImageIO

extension UIImage {

    private static let gifCache = NSCache<NSString, UIImage>()

    private static let maxAnimationFrames = 120

    public class func gifImageWithName(_ name: String, speed: Double = 1.0) -> UIImage? {
        let cacheKey = "\(name)@\(speed)" as NSString
        if let cached = gifCache.object(forKey: cacheKey) {
            return cached
        }

        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {
            gifLog("SwiftGif: image named \"\(name)\" does not exist")
            return nil
        }
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            gifLog("SwiftGif: cannot turn image named \"\(name)\" into Data")
            return nil
        }

        guard let image = gifImageWithData(imageData, speed: speed) else {
            return nil
        }

        gifCache.setObject(image, forKey: cacheKey)
        return image
    }

    public class func gifImageWithData(_ data: Data, speed: Double = 1.0) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            gifLog("SwiftGif: source for the image does not exist")
            return nil
        }

        return animatedImageWithSource(source, speed: speed)
    }

    /// Reads the frame delay for a given index.
    ///
    /// The previous implementation used `unsafeBitCast` on raw
    /// `CFDictionaryGetValue` results and a `as! Double` force cast, both of
    /// which crash on GIFs with unusual or missing metadata. This version
    /// walks the properties dictionary through normal Swift bridging and
    /// falls back to the default delay whenever anything is missing.
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        let defaultDelay = 0.1

        guard let source = source,
              let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any] else {
            return defaultDelay
        }

        // Unclamped delay is the more accurate value; fall back to the clamped
        // one when it is absent or zero.
        let unclamped = (gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? NSNumber)?.doubleValue
        let clamped = (gifProperties[kCGImagePropertyGIFDelayTime] as? NSNumber)?.doubleValue

        var delay = defaultDelay
        if let unclamped = unclamped, unclamped > 0 {
            delay = unclamped
        } else if let clamped = clamped, clamped > 0 {
            delay = clamped
        }

        return max(delay, defaultDelay)
    }

    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        guard var a = a, var b = b else {
            return b ?? a ?? 0
        }

        if a < b {
            swap(&a, &b)
        }

        while b != 0 {
            let rest = a % b
            a = b
            b = rest
        }

        return a
    }

    class func gcdForArray(_ array: Array<Int>) -> Int {
        guard var gcd = array.first else {
            return 1
        }

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return max(gcd, 1)
    }

    class func animatedImageWithSource(_ source: CGImageSource, speed: Double) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        guard count > 0 else { return nil }

        // Frames whose CGImage fails to decode are skipped together with their
        // delay, so images and delays always stay index-aligned. Previously a
        // failed decode shifted every following delay onto the wrong frame.
        var images = [CGImage]()
        var delays = [Int]()
        images.reserveCapacity(count)
        delays.reserveCapacity(count)

        let safeSpeed = speed > 0 ? speed : 1.0

        for i in 0..<count {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else { continue }
            images.append(image)

            let delaySeconds = UIImage.delayForImageAtIndex(i, source: source)
            delays.append(Int(delaySeconds * 1000.0 / safeSpeed))
        }

        guard !images.isEmpty else { return nil }

        let duration = delays.reduce(0, +)
        let gcd = gcdForArray(delays)

        // Frame slots the naive expansion would produce.
        let rawSlotCount = delays.reduce(0) { $0 + max($1 / gcd, 1) }
        // Scale the repeat counts down when the expansion is oversized.
        let slotDivisor = max(1, Int((Double(rawSlotCount) / Double(maxAnimationFrames)).rounded(.up)))

        var frames = [UIImage]()
        frames.reserveCapacity(min(rawSlotCount, maxAnimationFrames))

        for i in 0..<images.count {
            let frame = UIImage(cgImage: images[i])
            let frameCount = max(delays[i] / gcd / slotDivisor, 1)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        return UIImage.createGIFAnimation(images: frames, duration: Double(duration) / 1000.0)
    }

    public class func createGIFAnimation(images: [UIImage], duration: TimeInterval) -> UIImage? {
        return UIImage.animatedImage(with: images, duration: duration)
    }

    private class func gifLog(_ message: String) {
        #if DEBUG
        print(message)
        #endif
    }
}
