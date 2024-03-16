//Created for BritCitizenship Life in the UK in 2024
// Using Swift 5.0

import SwiftUI


enum VersionNetworkError : Error {
    case httpError
}

public struct UpdateVersionView: View {
    
    public let link:String  // link to the url of the  app we want to update
    public let serverJSON: String  // server that servers the app version number
    @State private var isCheckingVersion = false
    @State private var warningText = ""
    @State private var updated = false
    @Environment(\.openURL) var openURL
    
    
    public init(link: String, serverJSON: String ) {
        self.link = link
        self.serverJSON = serverJSON
        self.isCheckingVersion = isCheckingVersion
        self.warningText = warningText
        self.updated = updated
    }
    
    
    public var body: some View {
        
        HStack{
            
            AppInformationView(versionString: AppVersionProvider.appVersion(), appIcon: AppIconProvider.appIcon() )
            Button() {
                isCheckingVersion = true
                //
                Task.init {
                    warningText = "" // reset
                    do {
                        let info = try await checkLastVersion()
                        isCheckingVersion = false
                        
                        guard let info = info else {
                            warningText = "**The Internet connection appears to be offline**"
                            updated = false
                            
                            return
                        }
                        
                        if AppVersionProvider.appVersion() == info[0].version {
                            warningText = "**Your device is updated** - Version \(info[0].version)"
                            updated = true
                        } else {
                            let update = "There is a new version. Tap  [here ](link) to update"
                            warningText = update
                        }
                    }catch {
                        print(error)
                    }
                }
            } label: {
                Text("Update ...")
            }.buttonStyle(.borderedProminent)
                .padding(.leading, 40)
            
        }
        HStack {
            
            if  isCheckingVersion {
                ProgressView("Checking")
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.red))
                    .padding()
            }
            
            HStack {
                if updated {
                    Image(systemName: "checkmark.circle").foregroundColor(.red)
                }
                Text(.init(warningText))
                    .environment(\.openURL, OpenURLAction { url in
                           
                           // Do something here...
                        openURL(URL(string: link)!)
                           return .handled
                       })
                
            }.opacity(isCheckingVersion ? 0 : 1)
            
        }
        
        
    }
    
     func checkLastVersion() async throws  -> Info? {
         var response: Info?
            try  await Task.sleep(for: .seconds(2.0))
         
        let endPointURL = URL(string: serverJSON)!
         do {
             response = try await checkVersion(from: endPointURL)
         } catch {
             return nil
         }
        return response
    }
    
     func checkVersion(from url: URL) async throws -> Info? {
        
        let (data, response) = try await URLSession.shared.data(from: url)
         guard let httpResponse = (response as? HTTPURLResponse),
                     200...299 ~= httpResponse.statusCode else {
             throw VersionNetworkError.httpError
             }
         
         
         
        print(response)
        let decoder = JSONDecoder()
        return try decoder.decode(Info.self, from: data)
    }
    
    
}






struct UpdateVersionView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateVersionView(link: "https://apps.apple.com/gb/app/life-in-the-uk-test-discovery/id1673106818)", serverJSON: "https://delightful-bonbon-cf67ee.netlify.app/versionLifeUK")
    }
}




