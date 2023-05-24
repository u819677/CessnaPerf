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
    @Binding var showPDFUIView: Bool
    let pdfDoc: PDFDocument
    init(showPDFUIView: Binding<Bool>) {
        let url = Bundle.main.url(forResource: "C172Perf", withExtension: "pdf")!
        pdfDoc = PDFDocument(url: url)!
        self._showPDFUIView = showPDFUIView
    }
    var body: some View {
        VStack{
            PDFKitView(showing: pdfDoc)
            Spacer()
            Button("OK") {
                showPDFUIView = false
            }
            .padding(30)
            .overlay(RoundedRectangle(cornerRadius: 15)
                .stroke(Color(skyBlue), lineWidth: 3)
            )
        }
    }
}
//struct FileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileView()
//    }
//}
