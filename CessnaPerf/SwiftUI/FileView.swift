//
//  FileView.swift
//  CessnaPerf
//
//  Created by Richard Clark on 20/05/2023.
//

import SwiftUI
import PDFKit


struct FileView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var dataFile: String?
    let pdfC172P: PDFDocument
    let pdfC182RG: PDFDocument
    init(dataFile: Binding<String?>) {
        let urlC172P = Bundle.main.url(forResource: "C172Pinfo", withExtension: "pdf")!
        pdfC172P = PDFDocument(url: urlC172P)!
        let urlC182RG = Bundle.main.url(forResource: "C182RGinfo", withExtension: "pdf")!
        pdfC182RG = PDFDocument(url: urlC182RG)!
        self._dataFile = dataFile
    }
    var body: some View {
        VStack{
            if dataFile == "C172P" {
                uiKitPDFView(showing: pdfC172P)
            } else if dataFile == "C182RG" {
                uiKitPDFView(showing: pdfC182RG)
            }
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


//struct FileView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileView()
//    }
//}
