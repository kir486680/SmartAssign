//
//  PDFViewController.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 3/31/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    public var documentData: Data?
    @IBOutlet weak var pdfView: PDFView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let pdfCreator = createPDF(title: passedName, image: imageArrayWatch[0])
        let pdfData = pdfCreator.createFlyer()
        let pdfDocument = PDFDocument(data: pdfData)
        print()
        if imageArrayWatch.count > 1{
            print("Here in count", imageArrayWatch.count)
            for i in 1...imageArrayWatch.count-1{
                print(i)
                var pdfTempCreator = createPDF(title: passedName, image: imageArrayWatch[i])
                let pdfTempData = pdfTempCreator.createFlyer()
                let pdfTeampDocument = PDFDocument(data: pdfTempData)
                let page = pdfTeampDocument!.page(at: 0)
                pdfDocument?.insert(page!, at: i)
            }  
            
        }
        pdfView.document = pdfDocument

        
        //print(type(of: pdfData))
    
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


class createPDF{
    
    let title: String
    let image: UIImage

    
    init(title: String, image: UIImage) {
      self.title = title
      self.image = image

    }
    
    func createFlyer() -> Data {
      // 1
      let pdfMetaData = [
        kCGPDFContextCreator: "Flyer Builder",
        kCGPDFContextAuthor: "raywenderlich.com",
        kCGPDFContextTitle: title
      ]
      let format = UIGraphicsPDFRendererFormat()
      format.documentInfo = pdfMetaData as [String: Any]
      
      // 2
      let pageWidth = 8.5 * 72.0
      let pageHeight = 11 * 72.0
      let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
      
      // 3
      let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
      // 4
      let data = renderer.pdfData { (context) in
        // 5
        context.beginPage()
        // 6
        let titleBottom = addTitle(pageRect: pageRect)
        let imageBottom = addImage(pageRect: pageRect, imageTop: titleBottom + 18.0)
        //addBodyText(pageRect: pageRect, textTop: imageBottom + 18.0)
        
        let context = context.cgContext
        //drawTearOffs(context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 8)
        //drawContactLabels(context, pageRect: pageRect, numberTabs: 8)
      }
      
      return data
    }
    func addTitle(pageRect: CGRect) -> CGFloat {
      // 1
      let titleFont = UIFont.systemFont(ofSize: 18.0, weight: .bold)
      // 2
      let titleAttributes: [NSAttributedString.Key: Any] =
        [NSAttributedString.Key.font: titleFont]
      let attributedTitle = NSAttributedString(string: title, attributes: titleAttributes)
      // 3
      let titleStringSize = attributedTitle.size()
      // 4
      let titleStringRect = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0,
                                   y: 36, width: titleStringSize.width,
                                   height: titleStringSize.height)
      // 5
      attributedTitle.draw(in: titleStringRect)
      // 6
      return titleStringRect.origin.y + titleStringRect.size.height
    }
    func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
      // 1
      let maxHeight = pageRect.height * 0.4
      let maxWidth = pageRect.width * 0.8
      // 2
      let aspectWidth = maxWidth / image.size.width
      let aspectHeight = maxHeight / image.size.height
      let aspectRatio = min(aspectWidth, aspectHeight)
      // 3
      let scaledWidth = image.size.width * aspectRatio
      let scaledHeight = image.size.height * aspectRatio
      // 4
      let imageX = (pageRect.width - scaledWidth) / 2.0
      //print("X", imageX, "y", imageTop)
      let imageRect = CGRect(x: 1, y: 60,
                             width: scaledWidth, height: scaledHeight)
      // 5
      image.draw(in: imageRect)
      return imageRect.origin.y + imageRect.size.height
    }
    func drawTearOffs(_ drawContext: CGContext, pageRect: CGRect,
                      tearOffY: CGFloat, numberTabs: Int) {
      // 2
      drawContext.saveGState()
      drawContext.setLineWidth(2.0)
      
      // 3
      drawContext.move(to: CGPoint(x: 0, y: tearOffY))
      drawContext.addLine(to: CGPoint(x: pageRect.width, y: tearOffY))
      drawContext.strokePath()
      drawContext.restoreGState()
      
      // 4
      drawContext.saveGState()
      let dashLength = CGFloat(72.0 * 0.2)
      drawContext.setLineDash(phase: 0, lengths: [dashLength, dashLength])
      // 5
      let tabWidth = pageRect.width / CGFloat(numberTabs)
      for tearOffIndex in 1..<numberTabs {
        // 6
        let tabX = CGFloat(tearOffIndex) * tabWidth
        drawContext.move(to: CGPoint(x: tabX, y: tearOffY))
        drawContext.addLine(to: CGPoint(x: tabX, y: pageRect.height))
        drawContext.strokePath()
      }
      // 7
      drawContext.restoreGState()
    }
    

}


