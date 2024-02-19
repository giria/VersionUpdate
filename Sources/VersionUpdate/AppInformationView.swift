

import SwiftUI

public struct AppInformationView: View {
    
    let versionString: String
    let appIcon: String
    
    public var body: some View {
        
        VStack(alignment: .center, spacing: 12) {
            
            // App icons can only be retrieved as named `UIImage`s
            // https://stackoverflow.com/a/62064533/17421764
            if let image = UIImage(named: appIcon) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .frame(height: 100)
            }
            
            VStack(alignment: .leading) {
                Text("Version")
                    .bold()
                Text("v\(versionString)")
                
            }
            .font(.caption)
            .foregroundColor(.primary)
        }.padding()
            .border(.green)
        
            .fixedSize()
        
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("App version \(versionString)")
    }
}

struct AppInformationView_Previews: PreviewProvider {
    static var previews: some View {
        AppInformationView(versionString: AppVersionProvider.appVersion(), appIcon: AppIconProvider.appIcon() )
    }
}
