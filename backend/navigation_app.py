from flask import Flask, request, jsonify,send_from_directory
import folium
from fuzzywuzzy import process
from flask_cors import CORS
import os 
app = Flask(__name__)
CORS(app)


Coordinates_list = {
    "vsbhostel": ("22.531799", "75.923740"), "vsb": ("22.531799", "75.923740"),
    "hjbhostel": ("22.532027", "75.924920"), "hjb": ("22.532027", "75.924920"),
    "cvrhostel": ("22.532418", "75.924100"), "cvr": ("22.532418", "75.924100"),
    "dahostel": ("22.531091", "75.923477"), "da": ("22.531091", "75.923477"),
    "apjhostel": ("22.530649", "75.924293"), "apj": ("22.530649", "75.924293"),
    "jcbhostel": ("22.527647", "75.925087"), "jcb": ("22.527647", "75.925087"),
    "healthcentre": ("22.525538", "75.926304"), "hospital": ("22.525538", "75.926304"),
    "lrc": ("22.528980", "75.922651"), "learningresourcecentre": ("22.528980", "75.922651"),
    "busstop": ("22.528980", "75.922651"),
    "nescafe": ("22.528662", "75.923880"),
    "dominos": ("22.528717", "75.924604"),
    "lafresco": ("22.530310", "75.922997"),
    "narmadahallofresidence": ("22.523546", "75.922418"), "narmada": ("22.523546", "75.922418"),
    "kshiprahallofresidence": ("22.522986", "75.925342"), "kshipra": ("22.522986", "75.925342"),
    "shribalhanumanmandir": ("22.531766", "75.920570"), "mandir": ("22.531766", "75.920570"),
    "masjid": ("22.531766", "75.920570"),
    "sportscomplex": ("22.531766", "75.920570"),
    "abhinandanbhavan": ("22.528392", "75.921498"),
    "centralworkshop": ("22.525890", "75.921361"),
    "citc": ("22.525479", "75.921723"),
    "hvacplant": ("22.525479", "75.921723"),
    "sewagetreatmentplant": ("22.535066", "75.929185"),
    "maalaundry": ("22.535066", "75.929185"), "laundry": ("22.535066", "75.929185"),
    "cyclerepairshop": ("22.532453", "75.921426"),
    "gate1a": ("22.529529", "75.912679"),
    "gate1b": ("22.528566", "75.917104"),
    "gate2": ("22.51901", "75.91561"),
    "nalandaauditorium": ("22.526413", "75.924341"), "lhc": ("22.526413", "75.924341"),
    "lecturehallcomplex": ("22.526413", "75.924341"),
    "takshilla": ("22.526413", "75.924341"),
    "vikramshilla": ("22.526413", "75.924341"),
    "pod1b": ("22.529405", "75.924169"),
    "pod1a": ("22.529058", "75.924502"),
    "pod1c": ("22.529388", "75.923327"),
    "pod1d": ("22.529091", "75.923440"),
    "pod1e": ("22.528833", "75.923469"),
    "amul": ("22.5296329", "75.9252789"),
    "jucilicious": ("22.5294523", "75.9251020"), "juicy": ("22.5294523", "75.9251020"),
    "centraldinninghall": ("22.528975", "75.925320"), "mess": ("22.528975", "75.925320"),
    "shirucafe": ("22.5298652", "75.9248066"),
    "ascanteen": ("22.5305232", "75.9251028"),
    "villagecafe": ("22.5301604", "75.9248613"),
    "zippycafe": ("22.5302921", "75.9250271"),
    "vindhyachalguesthouse": ("22.524173", "75.925806"), "guesthouse": ("22.524173", "75.925806"),
    "kendriyavidyalay": ("22.520518", "75.921179"), "kv": ("22.520518", "75.921179"),
    "sic": ("22.521581", "75.921275"),
    "directorbungalow": ("22.519991", "75.923220"),
    "ravechi": ("22.528719", "75.922541"),
    "dailyneeds": ("22.529453", "75.925443"), "dn": ("22.529453", "75.925443"),
    "fruitsshop": ("22.5302106", "75.9229220"),
    "parkingnalanda": ("22.526581", "75.923558"),
    "parkinglrc": ("22.528147", "75.922847"),
    "parkingpod": ("22.528110", "75.924725"),
    "parkinghc": ("22.525630", "75.926060"),
    "parkingsportscomplex": ("22.529906", "75.920111"),
    "canarabank": ("22.5303037", "75.9228661"),
    "sbiatm": ("22.5253889", "75.9210500")
}

word_list = [
    "vsbhostel", "hjbhostel", "cvrhostel", "dahostel", "apjhostel",
    "healthcentre", "lrc", "nescafe", "dominos", "lafresco",
    "narmada", "kshipra", "shribalhanumanmandir", "busstop",
    "sportscomplex", "abhinandanbhavan", "centralworkshop", "citc",
    "hvacplant", "sewagetreatmentplant", "maalaundry", "cycldaerepairshop",
    "gate1a", "gate1b", "gate2", "nalandaauditorium", "pod1b", "pod1a",
    "pod1c", "pod1d", "pod1e", "amul", "jucilicious",
    "centraldinninghall", "shirucafe", "ascanteen", "villagecafe",
    "zippycafe", "vindhyachalguesthouse", "kendriyavidyalay", "sic",
    "directorbungalow", "ravechi", "dailyneeds", "fruitsshop", "parkingnalanda",
    "parkinglrc", "parkinghc", "parkingsportscomplex", "vsb", "hjb", "cvr", "da", "apj",
    "jcb", "hospital", "learningresourcecentre", "narmadahallofresidence",
    "kshiprahallofresidence", "masjid", "mandir", "laundry", "lecturehallcomplex", "lhc",
    "takshilla", "vikramshilla", "juicy", "mess", "kv", "dn", "guesthouse", "canarabank",
    "sbiatm"
]

def autocorrect(word, wordlist):
    return process.extractOne(word, wordlist)[0]

# def get_closest_location(location):
#     closest_match = process.extractOne(location, Coordinates_list.keys())
#     return closest_match[0] if closest_match else None


@app.route('/get_map', methods=['POST'])
def get_map():
    data = request.json
    start_location = data.get("start").lower().replace(" ", "")
    end_location = data.get("end").lower().replace(" ", "")

    try:
        start_location = autocorrect(start_location, word_list)
        end_location = autocorrect(end_location, word_list)

        start_coords = Coordinates_list.get(start_location)
        end_coords = Coordinates_list.get(end_location)

        if not start_coords or not end_coords:
            raise ValueError("Invalid start or end location provided.")

        start_lat, start_lon = map(float, start_coords)
        end_lat, end_lon = map(float, end_coords)

       
        html_code = f"""<!DOCTYPE html>
        <html>
        <head>
            <title>IIT Indore Navigation</title>
            <meta charset="utf-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <link rel="stylesheet" href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css" />
            <link rel="stylesheet" href="https://unpkg.com/leaflet-routing-machine/dist/leaflet-routing-machine.css" />
            <style>
                #map {{ height: 100vh; width: 100%; }}
            </style>
        </head>
        <body>
            <div id="map"></div>
            <script src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"></script>
            <script src="https://unpkg.com/leaflet-routing-machine/dist/leaflet-routing-machine.js"></script>
            <script>
                var map = L.map('map').setView([{start_lat}, {start_lon}], 15);
                L.tileLayer('https://{{s}}.tile.openstreetmap.org/{{z}}/{{x}}/{{y}}.png', {{
                    attribution: '© OpenStreetMap contributors'
                }}).addTo(map);

                var start = L.latLng({start_lat}, {start_lon});
                var end = L.latLng({end_lat}, {end_lon});

                L.marker(start, {{title: "Start"}}).addTo(map).bindPopup("Start Location");
                L.marker(end, {{title: "End"}}).addTo(map).bindPopup("End Location");

                L.Routing.control({{
                    waypoints: [start, end],
                    routeWhileDragging: true,
                    createMarker: function(i, wp, n) {{
                        return L.marker(wp.latLng, {{
                            title: i === 0 ? "Start" : "End"
                        }});
                    }}
                }}).addTo(map);
            </script>
        </body>
        </html>
        """

        map_path = os.path.join("static", "map.html")
        with open(map_path, "w", encoding="utf-8") as file:
            file.write(html_code)

        return jsonify({"message": "Map generated successfully", "map_path": map_path})

    except Exception as e:
        return jsonify({"message": "Error generating map", "error": str(e)}), 400
        
@app.route('/static/map.html')
def serve_map():
    return send_from_directory('static', 'map.html')



if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=8000)