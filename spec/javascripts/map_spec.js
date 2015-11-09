var L = {
    mapbox: {
        map: function () {}
    },
    divIcon: function () {},
    marker: function() {},
    divIcon: function() {}
};
var fakeMap;
var fakeMarker;
var fakeIcon = "foo";

describe("the map", function () {
    beforeAll(function() {
        jasmine.Ajax.install();
    });

    beforeEach(function () {
        fakeMap = {
            setView: jasmine.createSpy("setView"),
            scrollWheelZoom: {
                disable: jasmine.createSpy("disable")
            }
        };
        fakeMap.setView.and.returnValue(fakeMap);
        spyOn(L.mapbox, "map").and.returnValue(fakeMap);
        spyOn(L, "marker").and.returnValue(fakeMarker);
        fakeMarker = {addTo: jasmine.createSpy("addTo")};
        spyOn(L, "divIcon").and.returnValue(fakeIcon);
        loadMap();
    });

    it("loads the map on landing page", function () {
        expect(fakeMap.setView).toHaveBeenCalledWith([24.5465, -98.5795], 3);
    });

    it("makes an ajax request for the lat long data", function () {
        request = jasmine.Ajax.requests.mostRecent();
        expect(request.url).toBe('/api/v1/incidents.json');
        expect(request.method).toBe('GET');
    })

    it("puts the pins on the map", function() {
        request = jasmine.Ajax.requests.mostRecent();
        request.respondWith({"status": 200, "responseText": '[{"latitude": "33.745989", "longitude": "-117.93968"},{"latitude": "30.8137", "longitude": "-88.3332"}]'});

        expect(L.marker.calls.count()).toEqual(2);
        expect(L.marker.calls.argsFor(0)).toEqual([['33.745989', '-117.93968'], { icon: fakeIcon }]);
        expect(L.marker.calls.argsFor(1)).toEqual([['30.8137', '-88.3332'], { icon: fakeIcon }]);
    })
});