//
//  FileView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 20/05/2023.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    let pdfDocument: PDFDocument
    
    init(showing pdfDoc: PDFDocument){
        self.pdfDocument = pdfDoc
    }
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
       // pdfView.autoScales = false//true
        pdfView.minScaleFactor = 1.5
        
        return pdfView
    }
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}
struct PDFUIView: View {
    let pdfDoc: PDFDocument
    init() {
        let url = Bundle.main.url(forResource: "C172Perf", withExtension: "pdf")!
        pdfDoc = PDFDocument(url: url)!
    }
    var body: some View {
        PDFKitView(showing: pdfDoc)
    }
}
//struct FileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileView()
//    }
//}
