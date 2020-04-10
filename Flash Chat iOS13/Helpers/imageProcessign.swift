//
//  imageProcessign.swift
//  Flash Chat iOS13
//
//  Created by Kirill Kalashnikov on 3/31/20.
//  Copyright © 2020 Angela Yu. All rights reserved.
//

import Foundation
import UIKit
import PDFKit

func drawPDFfromURL(url: URL) -> UIImage? {
    guard let document = CGPDFDocument(url as CFURL) else { return nil }
    guard let page = document.page(at: 1) else { return nil }

    let pageRect = page.getBoxRect(.mediaBox)
    let renderer = UIGraphicsImageRenderer(size: pageRect.size)
    let img = renderer.image { ctx in
        UIColor.white.set()
        ctx.fill(pageRect)

        ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
        ctx.cgContext.scaleBy(x: 1.0, y: -1.0)

        ctx.cgContext.drawPDFPage(page)
    }

    return img
}

func downloadFromServer(url: [String]){
    
    for i in url{
    let i = URL(string: i)
        print("I" , i)
        URLSession.shared.dataTask(with: i!) { data, response, error in
         guard
             let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
             let data = data, error == nil,
             let image = UIImage(data: data)
             
             else { return }
            print("Here", image)
         DispatchQueue.main.async() {
            print("Appended")
            imageArrayWatch.append(image)
         }
         }.resume()
    }

}
