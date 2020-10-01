import Foundation
import AVFoundation
import UIKit

public class ImagesToVideoUtils: NSObject {
    
    static let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    static let tempPath = paths[0] + "/exprotvideo.mp4"
    static let fileURL = URL(fileURLWithPath: tempPath)
    var assetWriter:AVAssetWriter!
    var writeInput:AVAssetWriterInput!
    var bufferAdapter:AVAssetWriterInputPixelBufferAdaptor!
    var videoSettings:[String : Any]!
    var frameTime:CMTime!
    
    public init(videoSettings: [String: Any]) {
        super.init()
        
        
        if(FileManager.default.fileExists(atPath: ImagesToVideoUtils.tempPath)){
            guard (try? FileManager.default.removeItem(atPath: ImagesToVideoUtils.tempPath)) != nil else {
                print("remove path failed")
                return
            }
        }
        self.assetWriter = try! AVAssetWriter(url: ImagesToVideoUtils.fileURL, fileType: AVFileType.mov)
        self.videoSettings = videoSettings
        self.writeInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: videoSettings)
        assert(self.assetWriter.canAdd(self.writeInput), "add failed")
        self.assetWriter.add(self.writeInput)
        let bufferAttributes:[String: Any] = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32ARGB)]
        self.bufferAdapter = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: self.writeInput, sourcePixelBufferAttributes: bufferAttributes)
        self.frameTime = CMTimeMake(value: Int64(1), timescale: 1)
    }
    
    func createMovieFrom(images: [UIImage], withCompletion: @escaping (URL) -> Void){
        self.createMovieFromSource(images: images, extractor: {(inputObject:AnyObject) -> UIImage? in
            return inputObject as? UIImage}, withCompletion: withCompletion)
    }
    
    func createMovieFromSource(images: [AnyObject], extractor: @escaping (AnyObject) -> UIImage?, withCompletion: @escaping (URL) -> Void){
        
        self.assetWriter.startWriting()
        self.assetWriter.startSession(atSourceTime: CMTime.zero)
        
        let mediaInputQueue = DispatchQueue(label: "mediaInputQueue")
        var i = 0
        let frameNumber = images.count
        
        // add image
        self.writeInput.requestMediaDataWhenReady(on: mediaInputQueue){
            while(true){
                if(i >= frameNumber){ // check number if more than frame number is break
                    break
                }
                if (self.writeInput.isReadyForMoreMediaData){ // check if writer input is ready
                    var sampleBuffer:CVPixelBuffer?
                    autoreleasepool{
                        let img = extractor(images[i])
                        if img == nil{
                            i += 1
                            print("Warning: counld not extract one of the frames")
                        }
                        sampleBuffer = self.newPixelBufferFrom(cgImage: img!.cgImage!)
                    }
                    if (sampleBuffer != nil){
                        if(i == 0){
                            self.bufferAdapter.append(sampleBuffer!, withPresentationTime: CMTime.zero)
                        }else{
                            let value = i - 1
                            let lastTime = CMTimeMake(value: Int64(value), timescale: self.frameTime.timescale)
                            let presentTime = CMTimeAdd(lastTime, self.frameTime)
                            self.bufferAdapter.append(sampleBuffer!, withPresentationTime: presentTime)
                        }
                        i = i + 1
                    }
                }
            }
            self.writeInput.markAsFinished()
            self.assetWriter.finishWriting {
                DispatchQueue.main.sync {
                    withCompletion(ImagesToVideoUtils.fileURL)
                }
            }
        }
    }
    
    func newPixelBufferFrom(cgImage:CGImage) -> CVPixelBuffer? {
        // option pixel buffer image
        let options:[CFString: Any] = [
            kCVPixelBufferCGImageCompatibilityKey : true,
            kCVPixelBufferCGBitmapContextCompatibilityKey : true]
        
        var pxbuffer:CVPixelBuffer?
        let frameWidth = cgImage.width
        let frameHeight = cgImage.height
        
        
        // check buffer
        let status = CVPixelBufferCreate(kCFAllocatorDefault, frameWidth, frameHeight, kCVPixelFormatType_32ARGB, options as CFDictionary?, &pxbuffer)
        assert(status == kCVReturnSuccess && pxbuffer != nil, "newPixelBuffer failed")
        
        
        CVPixelBufferLockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pxdata = CVPixelBufferGetBaseAddress(pxbuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pxdata, width: frameWidth, height: frameHeight, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pxbuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        assert(context != nil, "context is nil")
        
        // create CGBitmapContext
        context!.concatenate(CGAffineTransform.identity)
        
        // Draw image into context
        context!.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
        CVPixelBufferUnlockBaseAddress(pxbuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pxbuffer
    }
}
