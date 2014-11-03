var app = angular.module('stockApp', ['templates', 'ui.router']);

app.config(function($stateProvider, $urlRouterProvider, $locationProvider) {
  $stateProvider
    .state('home', {
      url: '/',
      templateUrl: 'home.html',
      controller: 'HomeCtrl'
    });
  $urlRouterProvider.otherwise('/');
});