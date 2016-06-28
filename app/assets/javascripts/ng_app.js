var app = angular.module("attendant" , []);
app.controller("MenuCtrl" , function($scope ,  $http)  {

//    $scope.actions = ["Play text" , "Play custom media file" , "Play text and transfer to a number" , "Transfer to phone number",
//        "Transfer text and record caller" , "Repeat menu" , "Transfer to sub menu" , "Exit"
//    ]

    $scope.loadActions = function(){

//        $scope.actions = [{"id":7,"name":"Play text"},{"id":8,"name":"Play custom media file"},{"id":9,"name":"Play text and transfer to a number"},{"id":10,"name":"Transfer to phone number"},{"id":11,"name":"Transfer text and record caller"},{"id":12,"name":"Repeat menu"},{"id":13,"name":"Transfer to sub menu"},{"id":14,"name":"Exit"},{"id":15,"name":"No Action"}]

//        $http.get('/action_types.json').success(function(data){
//           $scope.actions = data;
//
//        });
    }


    $scope.update = function(){
        alert($scope.key_0_action)
    }



});