angular
  .module 'nscom.controllers.payments', []

  .controller 'paymentsNewController', [
    '$scope'
    '$state'
    '$stateParams'
    ($scope, $state, $stateParams) ->
      $scope.paid = false
      $scope.amount = 1
      $scope.checkout = (token) ->
        $scope.paid = true
  ]
