var myApp = angular.module('myApp', ['timer', 'angularMoment']);

myApp.controller('CountDownController', ['$scope', function ($scope) {

}]);

myApp.controller('ContactController', ['$scope', '$http', '$templateCache', function ($scope, $http, $templateCache) {

    $scope.time = new Date(); // date for dynamic Copyright Year

    $scope.submitbuttontext = 'Submit';
    $scope.contactData = {

        "MD's Office": {
            contacts: [{
                "title": "Ms.",
                "firstname": "Rachel",
                "lastname": "Misika",
                "position": "Executive Secretary to the MD",
                "tel": "+264 61 204 5060",
                "fax": "",
                "email": "RMisika@namcor.com.na"
            }]
        },
        "Communications and Public Relations": {
            contacts: [{
                "title": "Mr.",
                "firstname": "Utaara",
                "lastname": "Hoveka",
                "position": "Communications and Public Relations Specialist",
                "tel": "+264 61 204 5007",
                "fax": "+264 61 204 5030",
                "email": "UHoveka@namcor.com.na"
            }, {
                "title": "Ms.",
                "firstname": "Nangombe",
                "lastname": "Negumbo",
                "position": "Communications and Public Relations Assistant",
                "tel": "+264 61 204 5007",
                "fax": "+264 61 204 5030",
                "email": "NNegumbo@namcor.com.na"
            }]
        },
        "Commercial Business Unit": {
            contacts: [{
                "title": "Mr.",
                "firstname": "Michael",
                "lastname": "Shafudah",
                "position": "Development Officer: Retail",
                "tel": "+264 61 204 5083",
                "fax": "",
                "email": "MShafudah@namcor.com.na"
            }, {
                "title": "Ms.",
                "firstname": "Diana",
                "lastname": "Tsamases",
                "position": "Business Development Officer: Fuels and Lubricants",
                "tel": "+264 61 204 5081",
                "fax": "",
                "email": "DTsamases@namcor.com.na"
            }, {
                "title": "Ms.",
                "firstname": "Milly",
                "lastname": "Awaras",
                "position": "Business Development Officer: Fuels and Lubricants",
                "tel": "+264 61 204 5115",
                "fax": "",
                "email": "MAwaras@namcor.com.na"
            }]
        },
        "Supply & Distribution Division": {
            contacts: [{
                "title": "Ms.",
                "firstname": "Gasenosiwe",
                "lastname": "Phemelo",
                "position": "Administration and Stock Controller",
                "tel": "+264 61 204 5010",
                "fax": "",
                "email": "OPhemelo@namcor.com.na"
            }, {
                "title": "Ms.",
                "firstname": "Lee",
                "lastname": "Goliath",
                "position": "Product Coodinator",
                "tel": "+264 61 204 5082",
                "fax": "",
                "email": "LGoliath@namcor.com.na"
            }]
        },
        "Safety, Health, Environment and Quality (SHEQ)": {
            contacts: [{
                "title": "Mr.",
                "firstname": "Moses",
                "lastname": "Kavendjii",
                "position": "Safety, Health, Environment and Quality Officer",
                "tel": "+264 61 204 5117",
                "fax": "",
                "email": "MKavendjii@namcor.com.na "
            }]
        },
        "Upstream": {
            contacts: [{
                "title": "Mr.",
                "firstname": "Martin",
                "lastname": "Negonga",
                "position": "Geoscientist",
                "tel": "+264 61 204 5034",
                "fax": "+264 61 204 5007",
                "email": "MNegonga@namcor.com.na"
            }]
        }

    };

    $scope.formatContact = function (contact) {
        return contact.title + ' ' + contact.firstname + ' ' + contact.lastname + ' (' + contact.position + ')';
    };

    $scope.selectDepartment = function () { // select department
        angular.forEach($scope.contactData, function (departmentData, department) {
            if ($scope.user.department === department) {
                $scope.currentDepartment = departmentData;
                $scope.user.contact = departmentData.contacts[0];
                $scope.currentContact = $scope.user.contact;
                $scope.user.email = $scope.currentContact.email;
                var i = 0;
                angular.forEach(departmentData, function (contact) {

                    if (i == 0) {
                        ++i;
                        // $scope.user.contact = $scope.formatContact(contact);
                        // alert('Test');
                    }

                })
            }
        });
    };

    $scope.selectContact = function (contact) { // select contact
        $scope.currentContact = contact;
        $scope.user.email = $scope.currentContact.email;
    };


    /* send mail */

    var mailurl = "api/mail.php";
    var method = "POST";

    $scope.successmessage = null;
    $scope.errormessage = null;
    $scope.loading = false;
    $scope.submitbuttontext = "Submit";


    $scope.$on('$viewContentLoaded', function () { // triggered when the view is loaded
        //$scope.user.surname = '';
        //$scope.user.firstnames = '';
        //$scope.user.title = '';
        //$scope.user.company = '';
        //$scope.user.designation = '';
        //$scope.user.telephone = '';
        //$scope.user.mobile = '';
        //$scope.user.fax = '';
        //$scope.user.email = '';
        //$scope.user.postal = '';
        //$scope.user.physical = '';
    }); // on

    $scope.sendmail = function () { // posts json data to remote server for registration
        //console.log($scope.user.surname);

        $scope.response = null;
        $scope.loading = true;
        $scope.submitbuttontext = "Processing...";

        var requestData =
        {
            message: $scope.user.message,
            email: $scope.user.email
        }

        $http({method: method, url: mailurl, cache: $templateCache, data: requestData}).
            then(function (response) { // succeeded
                $scope.status = response.status;
                $scope.data = response.data;
                $scope.successmessage = "Your message was successfully send.";
                $scope.errormessage = null;
                $scope.loading = false;
                $scope.submitbuttontext = "Registered";

            }, function (response) { // failed
                $scope.data = response.data || "Request failed";
                $scope.status = response.status;
                $scope.errormessage = "Your message failed to send, please try again";
                $scope.sucessmessage = null;
                $scope.loading = false;
                $scope.submitbuttontext = "Submit";

            });


    }; // register



    var getRates = function () { // posts json data to remote server for registration

        var ratesurl = 'http://jsonrates.com/get/?from=USD&to=ZAR'
        requestoptions = {
            "base": "EUR",
            "date": "2016-04-15",
            "rates": {
                "AUD": 1.4648,
                "BGN": 1.9558,
                "BRL": 3.9387,
                "CAD": 1.4535,
                "CHF": 1.0919,
                "CNY": 7.3072,
                "CZK": 27.025,
                "DKK": 7.4414,
                "GBP": 0.79575,
                "HKD": 8.7527,
                "HRK": 7.5005,
                "HUF": 310.54,
                "IDR": 14862.67,
                "ILS": 4.2675,
                "INR": 75.1425,
                "JPY": 122.91,
                "KRW": 1295.12,
                "MXN": 19.7927,
                "MYR": 4.4085,
                "NOK": 9.3044,
                "NZD": 1.6334,
                "PHP": 52.051,
                "PLN": 4.2967,
                "RON": 4.4728,
                "RUB": 75.0125,
                "SEK": 9.1902,
                "SGD": 1.533,
                "THB": 39.584,
                "TRY": 3.2212,
                "USD": 1.1284,
                "ZAR": 16.4424
            }
        };

        $http({method: 'GET', url: ratesurl, cache: $templateCache, data: null}).
            then(function (response) { // succeeded
                console.log('Exchange Rates: ', response);
            }, function (response) { // failed
                console.log('Exchange Rates could not be loaded', response);
            });

    }; // register

    getRates(); // get current exchange rates

}]);