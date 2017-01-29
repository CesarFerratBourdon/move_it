// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap


//= require_tree .

var location1;
var location2;

function initialize() {

    var autocomplete1 = new google.maps.places.Autocomplete(
        (document.getElementById('autocomplete1')),
        { types: ['geocode'] });
    var autocomplete2 = new google.maps.places.Autocomplete(
        (document.getElementById('autocomplete2')),
        { types: ['geocode'] });
    google.maps.event.addListener(autocomplete1, 'place_changed', firstPlaceChanged);
    google.maps.event.addListener(autocomplete2, 'place_changed', secondPlaceChanged);

      function firstPlaceChanged () {
         var place1 = autocomplete1.getPlace();
         console.log(place1);
         lat1 = place1.geometry.location.lat().toString();
         lng1 = place1.geometry.location.lng().toString();
         city1 = place1.address_components[0].long_name;
         country1 = place1.address_components[3].short_name;
         console.log(city1);
         console.log(country1);

         $('#lat1').val(lat1);
         $('#lng1').val(lng1);
         $('#city1').val(city1);
         $('#country1').val(country1);
      };
      function secondPlaceChanged () {
         var place2 = autocomplete2.getPlace();
         console.log(place2);
         lat2 = place2.geometry.location.lat().toString();
         lng2 = place2.geometry.location.lng().toString();
         city2 = place2.address_components[0].long_name;
         country2 = place2.address_components[3].short_name;
         console.log(city2);
         console.log(country2);

         $('#lat2').val(lat2);
         $('#lng2').val(lng2);
         $('#city2').val(city2);
         $('#country2').val(country2);
      };
};


function transferInfo () {

  if (document.getElementById('piano1').checked) {
    var piano = document.getElementById('piano1').value;
  };
  if (document.getElementById('piano2').checked) {
    var piano = document.getElementById('piano2').value;
  };

  var new_rental = {
  origin: $('#origin').val(),
  destination: $('#destination').val(),
  lat1: $('#lat1').val(),
  lng1: $('#lng1').val(),
  lat2: $('#lat2').val(),
  lng2: $('#lng2').val(),
  city1: $('#city1').val(),
  country1: $('#country1').val(),
  city2: $('#city2').val(),
  country2: $('#country2').val(),
  size_living: $('#size_living').val(),
  size_basement: $('#size_basement').val(),
  piano: piano
  };

  localStorage.setItem("new-rental", JSON.stringify(new_rental));

  if (gon.id != null ){
    window.location.replace("/users/" + gon.id + "/show");
  } else {
    $('#login-signup').modal('toggle');
  }
};



function newRental () {

    if (localStorage.getItem("new-rental") !== null) {

      var newRental = JSON.parse(localStorage.getItem("new-rental"));
      console.log(newRental);
      $('#newQuote').attr('style','display: block');
      calcRoute(newRental);
    };
}

var directionsDisplay;
var directionsService = new google.maps.DirectionsService();
var map;

function calcRoute(newRental) {

  directionsDisplay = new google.maps.DirectionsRenderer();
  var chicago = new google.maps.LatLng(41.850033, -87.6500523);
  var mapOptions = {
    zoom:2,
    center: chicago,
  };
  map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);
  directionsDisplay.setMap(map);

  var request = {
      origin: new google.maps.LatLng(newRental.lat1,newRental.lng1),
      destination: new google.maps.LatLng(newRental.lat2,newRental.lng2),
      travelMode: google.maps.TravelMode.DRIVING
  };
  directionsService.route(request, function(response, status) {
    if (status == google.maps.DirectionsStatus.OK) {
      directionsDisplay.setDirections(response);
    }
  });

  var service = new google.maps.DistanceMatrixService();
    service.getDistanceMatrix({
        origins: [new google.maps.LatLng(newRental.lat1,newRental.lng1)],
        destinations: [new google.maps.LatLng(newRental.lat2,newRental.lng2)],
        travelMode: google.maps.TravelMode.DRIVING,
        unitSystem: google.maps.UnitSystem.METRIC,
        avoidHighways: false,
        avoidTolls: false
    }, function (response, status) {
        if (status == google.maps.DistanceMatrixStatus.OK && response.rows[0].elements[0].status != "ZERO_RESULTS") {
          //   var distance = response.rows[0].elements[0].distance.text;
          //   var divDistance = document.getElementById("divDistance");
          //  divDistance.innerHTML = "";
          //  divDistance.innerHTML += "Distance: " + distance + "<br />";
           var rental = {}
           rental["distance"] = response.rows[0].elements[0].distance.value;
           rental["piano"] = newRental.piano
           rental["city1"] = newRental.city1
           rental["city2"] = newRental.city2
           rental["size_living"] = newRental.size_living
           rental["size_basement"] = newRental.size_basement

          calculatePricing(rental);

        } else {
            alert("Unable to find the distance via road.");
        }
    });
}

function calculatePricing(rental){
    var request = $.get('/users/' + gon.id + '/calculatepricing', rental);

        function onSaveSuccess (response) {
          console.debug('Quote calculated!', response);
          saveRental(response);
        }

        function onSaveFailure (err) {
         console.error(err.responseJSON);
        }

    request.done(onSaveSuccess);
    request.fail(onSaveFailure);

}

function saveRental(quote){
    var request = $.post('/users/' + gon.id + '/createrental', quote);

        function onSaveSuccess (response) {
          console.debug('saved!', response);
          localStorage.removeItem("new-rental");
          var divPrice = document.getElementById("divPrice");
          divPrice.innerHTML = "<br><h2>New Quote</h2><br><br>";
          divPrice.innerHTML += "<h3>Price: " + response.total_price + " SEK</h3><br>";
          if (response.number_of_cars > 1) {
          divPrice.innerHTML += "<h4>" + response.number_of_cars + " Cars are required</h4>";
        } else {
          divPrice.innerHTML += "<h4>" + response.number_of_cars + " Car is required</h4>";
        };
          divPrice.innerHTML += "<h4>Total distance: " + response.distance + " km</h4>";
        }

        function onSaveFailure (err) {
         console.error(err.responseJSON);
        }

    request.done(onSaveSuccess);
    request.fail(onSaveFailure);

}
