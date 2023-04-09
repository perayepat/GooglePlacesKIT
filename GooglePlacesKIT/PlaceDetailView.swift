import SwiftUI

struct PlaceDetailView: View {
    var body: some View {
        VStack{
            placeHero
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .leading)
        .padding()
    }
}

struct PlaceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailView()
    }
}


//Components
extension PlaceDetailView{
    var placeHero: some View{
        VStack(alignment: .leading, spacing: 15){
            Text("Place Name")
                .font(.title)
                .bold()
            Text("place description")
            HStack {
                Image(systemName: "location.fill.viewfinder")
                    .font(.title2)
                Text("PlaceCode")
            }
        }
    }
}
