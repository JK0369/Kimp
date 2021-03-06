//
//  UIImageView.swift
//  TapRider
//
//  Created by Codigo Sheilar on 08/05/2020.
//  Copyright © 2020 42dot. All rights reserved.
//

import UIKit
import Kingfisher
import ImageIO

extension UIImageView {
    
    func setImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        kf.setImage(with: url)
    }
    
    func setImage(with urlString: String?, forceRefresh: Bool = false) {
        urlString.flatMap(URL.init)
            .then { setImage(with: $0, forceRefresh: forceRefresh) }
    }
    
    func setImage(with url: URL?, forceRefresh: Bool = false) {
        let options: KingfisherOptionsInfo = forceRefresh ? [.forceRefresh, .keepCurrentImageWhileLoading, .transition(.fade(0.15))]
            : [.keepCurrentImageWhileLoading, .transition(.fade(0.3))]
        
        kf.setImage(with: url, options: options)
    }
    
    func setImage(withBase64String base64String: String, key cacheKey: String, forceRefresh: Bool = false) {
        let options: KingfisherOptionsInfo = forceRefresh ? [.forceRefresh, .keepCurrentImageWhileLoading, .transition(.fade(0.15))]
            : [.keepCurrentImageWhileLoading, .transition(.fade(0.3))]
        
        let provider = Base64ImageDataProvider(base64String: base64String, cacheKey: cacheKey)
        
        kf.setImage(with: provider, options: options)
        
    }
    
    func showIndicatorWhileLoading(_ type: IndicatorType = .activity) {
        kf.indicatorType = type
    }
    
    func setImage(fromCache cacheKey: String) {
        ImageCache.default.retrieveImage(forKey: cacheKey) { result in
            switch result {
            case .success(let value):
//                Log.debug(value.cacheType)
                // If the `cacheType is `.none`, `image` will be `nil`.
//                Log.debug(value.image)
                self.image = value.image

            case .failure(let error):
                Log.error(error)
            }
        }
    }

}

func isCached(forKey cacheKey: String) -> Bool {
    let cache = ImageCache.default
    return cache.isCached(forKey: cacheKey)
}

func isCached(for cacheKey: String, isCached: () -> Void, noCache: () -> Void) {
    let cache = ImageCache.default
    let cached = cache.isCached(forKey: cacheKey)
    
    if cached {
        isCached()
    } else {
        noCache()
    }

}

extension UIImageView {

    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }

}

extension UIImage {

    public class func gif(data: Data) -> UIImage? {
        // Create source from data
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            Log.info("SwiftGif: Source for the image does not exist")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    public class func gif(url: String) -> UIImage? {
        // Validate URL
        guard let bundleURL = URL(string: url) else {
            Log.info("SwiftGif: This image named \"\(url)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            Log.info("SwiftGif: Cannot turn image named \"\(url)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    public class func gif(name: String) -> UIImage? {
        // Check for existance of gif
        guard let bundleURL = Bundle.main
          .url(forResource: name, withExtension: "gif") else {
            Log.info("SwiftGif: This image named \"\(name)\" does not exist")
            return nil
        }

        // Validate data
        guard let imageData = try? Data(contentsOf: bundleURL) else {
            Log.info("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
            return nil
        }

        return gif(data: imageData)
    }

    @available(iOS 9.0, *)
    public class func gif(asset: String) -> UIImage? {
        // Create source from assets catalog
        guard let dataAsset = NSDataAsset(name: asset) else {
            Log.info("SwiftGif: Cannot turn image named \"\(asset)\" into NSDataAsset")
            return nil
        }

        return gif(data: dataAsset.data)
    }

    internal class func delayForImageAtIndex(_ index: Int, source: CGImageSource!) -> Double {
        var delay = 0.1

        // Get dictionaries
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifPropertiesPointer = UnsafeMutablePointer<UnsafeRawPointer?>.allocate(capacity: 0)
        defer {
            gifPropertiesPointer.deallocate()
        }
        let unsafePointer = Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()
        if CFDictionaryGetValueIfPresent(cfProperties, unsafePointer, gifPropertiesPointer) == false {
            return delay
        }

        let gifProperties: CFDictionary = unsafeBitCast(gifPropertiesPointer.pointee, to: CFDictionary.self)

        // Get delay time
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties,
                Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }

        if let delayObject = delayObject as? Double, delayObject > 0 {
            delay = delayObject
        } else {
            delay = 0.1 // Make sure they're not too fast
        }

        return delay
    }

    internal class func gcdForPair(_ lhs: Int?, _ rhs: Int?) -> Int {
        var lhs = lhs
        var rhs = rhs
        // Check if one of them is nil
        if rhs == nil || lhs == nil {
            if rhs != nil {
                return rhs!
            } else if lhs != nil {
                return lhs!
            } else {
                return 0
            }
        }

        // Swap for modulo
        if lhs! < rhs! {
            let ctp = lhs
            lhs = rhs
            rhs = ctp
        }

        // Get greatest common divisor
        var rest: Int
        while true {
            rest = lhs! % rhs!

            if rest == 0 {
                return rhs! // Found it
            } else {
                lhs = rhs
                rhs = rest
            }
        }
    }

    internal class func gcdForArray(_ array: [Int]) -> Int {
        if array.isEmpty {
            return 1
        }

        var gcd = array[0]

        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }

        return gcd
    }

    internal class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()

        // Fill arrays
        for index in 0..<count {
            // Add image
            if let image = CGImageSourceCreateImageAtIndex(source, index, nil) {
                images.append(image)
            }

            // At it's delay in cs
            let delaySeconds = UIImage.delayForImageAtIndex(Int(index),
                source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }

        // Calculate full duration
        let duration: Int = {
            var sum = 0

            for val: Int in delays {
                sum += val
            }

            return sum
            }()

        // Get frames
        let gcd = gcdForArray(delays)
        var frames = [UIImage]()

        var frame: UIImage
        var frameCount: Int
        for index in 0..<count {
            frame = UIImage(cgImage: images[Int(index)])
            frameCount = Int(delays[Int(index)] / gcd)

            for _ in 0..<frameCount {
                frames.append(frame)
            }
        }

        // Heyhey
        let animation = UIImage.animatedImage(with: frames,
            duration: Double(duration) / 1000.0)

        return animation
    }

}
