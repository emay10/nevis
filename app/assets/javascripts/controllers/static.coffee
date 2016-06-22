angular
  .module 'nscom.controllers.static', []

  .controller 'staticDashboardController', [
    '$scope'
    '$state'
    '$stateParams'
    'Statement'
    ($scope, $state, $stateParams, Statement) ->
      Statement.query dash: true, (res) ->
        $scope.statements = res
  ]
