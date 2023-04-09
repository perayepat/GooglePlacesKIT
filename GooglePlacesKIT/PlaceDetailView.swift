import SwiftUI

struct PlaceDetailView: View {
    var weekDays = ["Monday: 10:00 AM – 9:00 PM", "Tuesday: 10:00 AM – 9:00 PM", "Wednesday: 10:00 AM – 9:00 PM", "Thursday: 10:00 AM – 9:00 PM", "Friday: 10:00 AM – 10:00 PM", "Saturday: 10:00 AM – 10:00 PM", "Sunday: 11:00 AM – 9:00 PM"]
    var place: Place?
    
    var body: some View {
        ScrollView {
            VStack{
                placeHero
                placeType
                workingHours
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
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
        VStack{
            Text(place?.name ?? "Title")
                .font(.title)
                .bold()
            VStack{
                Text(place?.address ?? "Addres")
                HStack {
                    Image(systemName: "location.fill.viewfinder")
                        .font(.title2)
                    Text(place?.plusCode ?? "")
                }
            }
            Text("Phone Number: \(place?.phoneNumber ?? "")")
            Text("webisite: link")
        }
    }
    
    var workingHours: some View{
        VStack{
            Text("Working hours")
                .font(.title)
                .bold()
            
            ForEach(place?.weekdays ?? [], id: \.self) { day in
                Text(day)
            }
        }
    }
    
    var placeType: some View{
        VStack{
            Text("Type")
                .font(.title)
                .bold()
            Text("Types")
        }
    }
}
