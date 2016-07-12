angular
  .module 'nscom.controllers.orders', []

  .controller 'ordersNewController', [
    '$scope'
    '$state'
    '$stateParams'
    'Order'
    ($scope, $state, $stateParams, Order) ->
      $scope.amount = 1
      order = new Order(amount: 100)
      $scope.update = ->
        order.amount = $scope.amount * 100
      $scope.paid = false
      $scope.checkout = (token) ->
        order.stripe_token = token.id
        order.$save ->
          $scope.paid = true
  ]
