/// Copyright (c) 2022 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import SwiftUI

struct ContentView: View {
  @StateObject var quoteViewModel = QuoteViewModel()
  @StateObject var imageViewModel = ImageViewModel()
  @State private var showAlert = false
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.white
          .edgesIgnoringSafeArea(.all)
        VStack(spacing: 0) {
          VStack(alignment: .center) {
            Text(Constants.Text.appTitle)
              .font(.largeTitle)
              .foregroundColor(.mint)
              .bold()
            Text(Constants.Text.appSubtitle)
              .font(.title)
              .foregroundColor(.mint)
          }
          .padding(.horizontal)

          ImageView(image: imageViewModel.image)
            .frame(
              width: geometry.size.width * 0.5,
              height: geometry.size.height * 0.2
            )
            .cornerRadius(10)
            .padding(30)
          QuoteView(quote: quoteViewModel.quote)
            .frame(
              width: geometry.size.width * 0.9,
              height: geometry.size.height * 0.5
            )
            .onTapGesture {
              // new code using async/await
              quoteViewModel.loadData()
              imageViewModel.loadData()
              // original code using dataTask
//              quoteViewModel.getQuotes()
//              imageViewModel.getImage()
            }
            .onReceive(quoteViewModel.$error) { error in
              if error != nil {
                showAlert.toggle()
              }
            }
            .alert(isPresented: $showAlert) {
              Alert(title: Text("Error"), message: Text(quoteViewModel.error?.localizedDescription ?? ""))
            }
          Spacer()
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
