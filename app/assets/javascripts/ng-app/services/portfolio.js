app.factory('Portfolio', ['$resource', function($resource) {
  return $resource(
    "/api/portfolios/:id",
    {id: "@id"},
    {
      update: {method: "PATCH"},
      update_cash: {
        method: "PATCH"
      }
    }
  );
}]);