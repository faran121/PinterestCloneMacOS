//
//  Home.swift
//  PinterestCloneMac
//
//  Created by Maliks on 30/03/2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct Home: View {
    
    var window = NSScreen.main?.visibleFrame
    var columns = Array(repeating: GridItem(.flexible(), spacing: 15), count: 4)
    
    @State var search = ""
    @StateObject var imageData = ImageViewModel()
    
    var body: some View {
        HStack {
            SideBar()
            
            VStack {
                HStack(spacing: 12) {
                    HStack(spacing: 15) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.gray)
                        
                        TextField("Search", text: $search)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    .background(BlurView())
                    .cornerRadius(10)
                    
                    Button(action: {}) {
                        Image(systemName: "slider.vertical.3")
                            .foregroundStyle(.black)
                            .padding(10)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                            .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {}) {
                        Image(systemName: "plus")
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.black)
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                GeometryReader { reader in
                    ScrollView {
                        LazyVGrid(columns: self.columns, spacing: 15, content: {
                            ForEach(imageData.images.indices, id: \.self) { index in
                                ZStack {
                                    WebImage(url: URL(string: imageData.images[index].download_url)!)
                                    //                                    .placeholder(content : {
                                    //                                        ProgressView()
                                    //                                    })
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: (reader.frame(in: .global).width - 45) / 4, height: 150)
                                        .cornerRadius(15)
                                    
                                    Color.black.opacity(imageData.images[index].onHover ?? false ? 0.2 : 0)
                                    
                                    VStack {
                                        HStack {
                                            Spacer(minLength: 0)
                                            
                                            Button(action: {}) {
                                                Image(systemName: "hand.thumbsup.fill")
                                                    .foregroundStyle(.yellow)
                                                    .padding(18)
                                                    .background(.white)
                                                    .cornerRadius(10)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            
                                            Button(action: { saveImage(index: index) }) {
                                                Image(systemName: "folder.fill")
                                                    .foregroundStyle(.blue)
                                                    .padding(18)
                                                    .background(.white)
                                                    .cornerRadius(10)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                        .padding(10)
                                        Spacer()
                                    }
                                    .opacity(imageData.images[index].onHover ?? false ? 1 : 0)
                                }
                                .onHover(perform: { hovering in
                                    withAnimation {
                                        imageData.images[index].onHover = hovering
                                    }
                                })
                            }
                        })
                        .padding(.vertical)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .ignoresSafeArea(.all, edges: .all)
        .frame(width: window!.width / 1.5, height: window!.height - 40)
        .background(Color.white.opacity(0.6))
        .background(BlurView())
    }
    
    private func saveImage(index: Int) {
        
        // Getting Image Data from the URL
        let manager = SDWebImageDownloader(config: .default)
        
        manager.downloadImage(with: URL(string: imageData.images[index].download_url)!) { (image, _, _, _) in
            guard let imageOrignal = image else { return }
            
            let data = imageOrignal.sd_imageData(as: .JPEG)
            
            // Saving Image
            
            let pannel = NSSavePanel()
            pannel.canCreateDirectories = true
            pannel.nameFieldStringValue = "\(imageData.images[index].id).jpg"
            
            pannel.begin { (response) in
                if response.rawValue == NSApplication.ModalResponse.OK.rawValue {
                    do {
                        try data?.write(to: pannel.url!, options: .atomicWrite)
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        

    }
}

#Preview {
    Home()
}

struct SideBar: View {
    
    @State var selectedTab: String  = "Home"
    @Namespace var animation
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(spacing: 22) {
                Group {
                    HStack {
                        Image("Logo")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                        Text("Pinterest Clone")
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        Spacer(minLength: 0)
                    }
                    .padding(.top, 35)
                    .padding(.leading, 10)
                    
                    TabButton(image: "house.fill", title: "Home", animation: self.animation, selected: $selectedTab)
                    TabButton(image: "clock.fill", title: "Recents", animation: self.animation, selected: $selectedTab)
                    TabButton(image: "person.2.fill", title: "Following", animation: self.animation, selected: $selectedTab)
                    
                    HStack {
                        Text("Insights")
                            .fontWeight(.semibold)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                    }
                    .padding()
                    
                    TabButton(image: "message.fill", title: "Messages", animation: self.animation, selected: $selectedTab)
                    TabButton(image: "bell.fill", title: "Nofications", animation: self.animation, selected: $selectedTab)
                }
                
                Spacer(minLength: 0)
                
                VStack(spacing: 8) {
                    Image("Business")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                    Button(action: {}) {
                        Text("Business Tools")
                            .fontWeight(.semibold)
                            .foregroundStyle(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Text("Hurry Up! Now you can unlock our new business tools at your convinence")
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 10)
                }
                
                Spacer(minLength: 0)
                
                HStack(spacing: 10) {
                    Image("Profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text("User")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        
                        Text("Last Login 30/03/24")
                            .font(.caption2)
                            .foregroundStyle(.gray)
                    })
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 5, y: 5)
                .shadow(color: .black.opacity(0.1), radius: 5, x: -5, y: -5)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            
            Divider()
                .offset(x: -2)
        }
        .frame(width: 240)
    }
}

extension NSTextField {
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}
