angular
  .module 'nscom.controllers.static', []

  .controller 'staticDashboardController', [
    '$scope'
    '$state'
    '$stateParams'
    ($scope, $state, $stateParams) -> console.log 1
  ]
