var app = angular.module('stockApp', [
  'ui.router',
  'templates',
  'mm.foundation'
]);

app.config(function ($stateProvider, $urlRouterProvider, $locationProvider) {
  $stateProvider
    .state('home', {
      url: '/',
      templateUrl: 'home.html',
      controller: 'HomeCtrl'
    });

    $urlRouterProvider.otherwise('/');
});