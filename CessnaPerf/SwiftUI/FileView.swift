//
//  FileView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 20/05/2023.
//

import SwiftUI
import PDFKit

struct uiKitPDFView: UIViewRepresentable {
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
struct FileView: View {
    @Environment(\.dismiss) var dismiss
    let pdfDoc: PDFDocument
    init() {
        let url = Bundle.main.url(forResource: "C172Perf", withExtension: "pdf")!
        pdfDoc = PDFDocument(url: url)!
    }
    var body: some View {
        VStack{
            uiKitPDFView(showing: pdfDoc)
            Spacer()
            Button("OK") {
              dismiss()
            }
            .padding(30)
            .overlay(RoundedRectangle(cornerRadius: 15)
                .stroke(Color(skyBlue), lineWidth: 3)
            )
            .contentShape(Rectangle())
            .onTapGesture {
               dismiss()
            }
        }
    }
}
//struct FileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileView()
//    }
//}
