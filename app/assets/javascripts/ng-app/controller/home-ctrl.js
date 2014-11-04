app.controller('HomeCtrl', ['$scope', 'Portfolio', 'User',
  function($scope, Portfolio, User) {

  $scope.portfolios = Portfolio.query();

  $scope.portfolios.$promise.then(function(data) {
    $scope.showPortfolios = (data.length !== 0)
  });

  User.currentUser.$promise.then(function(data) {
    $scope.isSignedIn = !data.guest;
  });

  $scope.newPortfolio = {};

  $scope.createPortfolio = function() {
    var portfolio = new Portfolio($scope.newPortfolio);
    portfolio.cash_balance = 0;
    portfolio.$save();
    $scope.portfolios.push(portfolio);
    $scope.newPortfolio = {};
  }
}]);