var app = angular.module('stockApp', [
  'ui.router',
  'templates'
]);

app.config(function ($stateProvider, $urlRouterProvider, $locationProvider) {
  $stateProvider
    .state('home', {
      url: '/',
      templateUrl: 'home.html',
      controller: 'HomeCtrl'
    });

    $urlRouterProvider.otherwise('/');

    $locationProvider.html5Mode(true);
});