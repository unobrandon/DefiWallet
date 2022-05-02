//
//  BlockAvatar.swift
//  DefiWallet
//
//  Created by Brandon Shaw on 4/29/22.
//

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

public final class BlockAvatar {

    // MARK: - Properties
    private var randSeed: [UInt32]

    public var seed: String

    public var size: Int
    public var scale: Int

    #if os(iOS) || os(tvOS) || os(watchOS)
    public typealias Colorr = UIColor
    public typealias Imagee = UIImage
    #elseif os(OSX)
    public typealias Colorr = NSColor
    public typealias Imagee = NSImage
    #endif

    public var color: Colorr
    public var bgColor: Colorr
    public var spotColor: Colorr

    // MARK: - Initialization
    /**
     * Initializes this instance of `BlockAvatar` with the given values or default values.
     *
     * - parameter seed: The seed to be used for this BlockAvatar. Defaults to random.
     * - parameter size: The number of blocks per side for this image. Defaults to 8.
     * - parameter scale: The number of pixels per block. Defaults to 4.
     * - parameter color: The foreground color. Defaults to random.
     * - parameter bgColor: The background color. Defaults to random.
     * - parameter spotColor: A color which forms mouths and eyes. Defaults to random.
     */
    public init(
        seed: String? = nil,
        size: Int = 8,
        scale: Int = 4,
        color: Colorr? = nil,
        bgColor: Colorr? = nil,
        spotColor: Colorr? = nil
    ) {
        let seed = seed ?? String(Int64(floor(Double.random * pow(10, 16))))
        self.seed = seed
        self.randSeed = BlockAvatarHelper.createRandSeed(seed: seed)
        self.size = size
        self.scale = scale
        self.color = color ?? Colorr()
        self.bgColor = bgColor ?? Colorr()
        self.spotColor = spotColor ?? Colorr()

        if color == nil {
            self.color = createColor()
        }
        if bgColor == nil {
            self.bgColor = createColor()
        }
        if spotColor == nil {
            self.spotColor = createColor()
        }
    }

    /**
     * Creates the BlockAvatar Image with currently set values.
     *
     * You can change the absolute size in pixels of the resulting image
     * by passing a `customScale` value which will result in the total pixel size
     * calculated as follows:
     *
     * `size * scale * customScale`
     *
     * For example: Default values `size = 8` and `scale = 4` result in an image
     * with 32x32px size. If you provide a `customScale` of `10`, you will get
     * an image with 320x320px in size.
     *
     * - parameter customScale: A scale factor which will be used to calculate the total image size.
     *
     * - returns: The generated image or `nil` if something went wrong.
     */
    public func createImage(customScale: Int = 1) -> Imagee? {
        let imageData = createImageData()

        return image(data: imageData, customScale: customScale)
    }

    private func rand() -> Double {
        let ttt = randSeed[0] ^ (randSeed[0] << 11)

        randSeed[0] = randSeed[1]
        randSeed[1] = randSeed[2]
        randSeed[2] = randSeed[3]
        let tmp = Int32(bitPattern: randSeed[3])
        let tmpT = Int32(bitPattern: ttt)
        randSeed[3] = UInt32(bitPattern: (tmp ^ (tmp >> 19) ^ tmpT ^ (tmpT >> 8)))

        // UInt for zero fill right shift
        // let divisor = (UInt32((1 << 31)) >> UInt32(0))
        let divisor = Int32.max

        return Double((UInt32(randSeed[3]) >> UInt32(0))) / Double(divisor)
    }

    private func createColor() -> Colorr {
        let hhh = Double(rand() * 360)
        let sss = Double(((rand() * 60) + 40)) / Double(100)
        let lll = Double((rand() + rand() + rand() + rand()) * 25) / Double(100)

        return Colorr.fromHSL(hhh: hhh, sss: sss, lll: lll) ?? Colorr.black
    }

    private func createImageData() -> [Double] {
        let width = size
        let height = size

        let dataWidth = Int(ceil(Double(width) / Double(2)))
        let mirrorWidth = width - dataWidth

        var data: [Double] = []
        for _ in 0 ..< height {
            var row = [Double](repeating: 0, count: dataWidth)
            for xxxx in 0 ..< dataWidth {
                // this makes foreground and background color to have a 43% (1/2.3) probability
                // spot color has 13% chance
                row[xxxx] = floor(Double(rand()) * 2.3)
            }
            let rrr = [Double](row[0 ..< mirrorWidth]).reversed()
            row.append(contentsOf: rrr)

            for iii in 0 ..< row.count {
                data.append(row[iii])
            }
        }

        return data
    }

    private func image(data: [Double], customScale: Int) -> Imagee? {
        let finalSize = size * scale * customScale
        #if os(iOS) || os(tvOS) || os(watchOS)
            UIGraphicsBeginImageContext(CGSize(width: finalSize, height: finalSize))
            let nilContext = UIGraphicsGetCurrentContext()
        #elseif os(OSX)
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
            let nilContext = CGContext(data: nil, width: finalSize, height: finalSize, bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        #endif

        guard let context = nilContext else {
            return nil
        }

        let width = Int(sqrt(Double(data.count)))

        context.setFillColor(bgColor.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: size * scale, height: size * scale))

        for iii in 0 ..< data.count {
            let row = Int(floor(Double(iii) / Double(width)))
            let col = iii % width

            let number = data[iii]

            let uiColor: Colorr
            if number == 0 {
                uiColor = bgColor
            } else if number == 1 {
                uiColor = color
            } else if number == 2 {
                uiColor = spotColor
            } else {
                uiColor = Colorr.black
            }

            context.setFillColor(uiColor.cgColor)
            context.fill(CGRect(x: CGFloat(col * scale * customScale), y: CGFloat(row * scale * customScale), width: CGFloat(scale * customScale), height: CGFloat(scale * customScale)))
        }

        #if os(iOS) || os(tvOS) || os(watchOS)
            let output = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return output
        #elseif os(OSX)
            guard let output = context.makeImage() else {
                return nil
            }

            return NSImage(cgImage: output, size: CGSize(width: finalSize, height: finalSize))
        #endif
    }
}

class BlockAvatarHelper {

    /**
     * Creates the initial version of the 4 UInt32 array for the given seed.
     * The result is equal for equal seeds.
     *
     * - parameter seed: The seed.
     *
     * - returns: The UInt32 array with exactly 4 values stored in it.
     */
    static func createRandSeed(seed: String) -> [UInt32] {
        var randSeed = [UInt32](repeating: 0, count: 4)
        for iii in 0 ..< seed.count {
            // &* and &- are the "overflow" operators. Need to be used there.
            // There is no overflow left shift operator so we do "&* pow(2, 5)" instead of "<< 5"
            randSeed[iii % 4] = ((randSeed[iii % 4] &* (2 << 4)) &- randSeed[iii % 4])
            let index = seed.index(seed.startIndex, offsetBy: iii)
            randSeed[iii % 4] = randSeed[iii % 4] &+ seed[index].asciiValue
        }

        return randSeed
    }
}

extension Double {

    /**
     * Generates a random number between 0 and 1 with `arc4random()`.
     */
    static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
}

extension Character {

    /**
     * Returns the value of the first 8 bits of this unicode character.
     * This is a correct ascii representation of this character if it is
     * an ascii character.
     */
    var asciiValue: UInt32 {
        get {
            let sss = String(self).unicodeScalars
            return sss[sss.startIndex].value
        }
    }
}
