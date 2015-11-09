var loadMap = function () {
    L.mapbox.accessToken = 'pk.eyJ1IjoibWFwcGluZy1wb2xpY2UtdmlvbGVuY2UiLCJhIjoiY2lmN293aXdzMHZienNxa3JmemlqNDNmZiJ9.XG0AwdE9SAqvMvg4_4MVlg';
    var map = L.mapbox.map('map', 'mapping-police-violence.cif7owhkn0vdoshlz0kybvksd')
        .setView([24.5465, -98.5795], 3);
    map.scrollWheelZoom.disable();
    this.addPinsToMap(map);
};

var addPinsToMap = function (map) {
    var mapPinIcon = L.divIcon({className: 'map-pin-icon', 'iconSize': 5});
    this.$.ajax('/api/v1/incidents.json').then(function (result) {
        for (var i = 0; i < result.length; i++) {
            var lat = result[i]['latitude'];
            var long = result[i]['longitude'];
            if (lat && lat !== 0 && long && long !== 0) {
                L.marker([lat, long], {
                    icon: mapPinIcon
                }).addTo(map);
            }
        }
    }, function () {});
}