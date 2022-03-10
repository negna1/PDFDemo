//
//  ViewController.swift
//  PDFDemo
//
//  Created by Nato Egnatashvili on 15.02.22.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pdfThumbnailAndPDFVIEW()
        createOwnPDF()
    }
    
    private func pdfThumbnailAndPDFVIEW() {
        let pdfView = PDFView()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        let thumbnailView = PDFThumbnailView()
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(thumbnailView)
        
        thumbnailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        thumbnailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        thumbnailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        pdfView.bottomAnchor.constraint(equalTo: thumbnailView.topAnchor).isActive = true
        thumbnailView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        thumbnailView.thumbnailSize = CGSize(width: 100, height: 100)
        thumbnailView.layoutMode = .horizontal
        thumbnailView.pdfView = pdfView
        
        let url = Bundle.main.url(forResource: "sample", withExtension: "pdf")
        guard let url = url,
              let  document = PDFDocument(url: url) else { return }
        pdfView.document = document
    }
    
    private func getYesAnnotation(x: CGFloat, text: String) -> PDFAnnotation{
        let textAnnotation = PDFAnnotation(bounds: CGRect(x: x, y: self.view.frame.maxY + 20, width: 20, height: 20),
                                           forType: PDFAnnotationSubtype(rawValue: PDFAnnotationSubtype.widget.rawValue),
                                           withProperties: nil)
        textAnnotation.widgetFieldType = PDFAnnotationWidgetSubtype(rawValue: PDFAnnotationWidgetSubtype.text.rawValue)
        
        textAnnotation.font = UIFont.systemFont(ofSize: 10)
        
        textAnnotation.fontColor = .red
        
        textAnnotation.isMultiline = true
        
        textAnnotation.widgetStringValue = text
        return textAnnotation
    }
    
    private func getRadioButton(x: CGFloat) -> PDFAnnotation{
        let radioButton = PDFAnnotation(bounds: CGRect(x: x, y: self.view.frame.maxY + 30, width: 10, height: 10), forType: .widget, withProperties: nil)
        radioButton.widgetFieldType = .button
        radioButton.widgetControlType = .radioButtonControl
        radioButton.backgroundColor = UIColor.gray
        return radioButton
    }
    
    func createOwnPDF() {
       
        let pdfView = PDFView(frame: view.frame)
        view.addSubview(pdfView)
        let pdfPage = PDFPage()
        let textAnnotation = PDFAnnotation(bounds: CGRect(x: 20, y: self.view.frame.maxY+60, width: 300, height: 24),
                                           forType: PDFAnnotationSubtype(rawValue: PDFAnnotationSubtype.widget.rawValue),
                                           withProperties: nil)
        textAnnotation.widgetFieldType = PDFAnnotationWidgetSubtype(rawValue: PDFAnnotationWidgetSubtype.text.rawValue)
        textAnnotation.font = UIFont.systemFont(ofSize: 15)
        textAnnotation.fontColor = .red
        textAnnotation.isMultiline = true
        textAnnotation.widgetStringValue = "Have you been music festival before?"
        
        pdfPage.addAnnotation(textAnnotation)
        pdfPage.addAnnotation(getYesAnnotation(x: 20, text: "Yes"))
        pdfPage.addAnnotation(getRadioButton(x: 45))
        pdfPage.addAnnotation(getYesAnnotation(x: 60, text: "No"))
        pdfPage.addAnnotation(getRadioButton(x: 85))
        
        let pdfDoc = PDFDocument()
        pdfDoc.insert(pdfPage, at: 0)
        pdfView.document = pdfDoc
            let button = UIButton(type: .contactAdd, primaryAction: .init(handler: { _ in
                
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                pdfDoc.write(toFile: "\(documentsPath)/file.pdf")
            }))
            button.widthAnchor.constraint(equalToConstant: 40).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button)
    }
    
}
