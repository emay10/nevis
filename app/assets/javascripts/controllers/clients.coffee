angular
  .module 'nscom.controllers.clients', []

  .controller 'clientsIndexController', [
    '$scope'
    '$state'
    '$stateParams'
    'Client'
    ($scope, $state, $stateParams, Client) ->
      Client.query (res) ->
        $scope.clients = res
  ]

  .controller 'clientsNewController', [
    '$scope'
    '$state'
    '$stateParams'
    'Client'
    ($scope, $state, $stateParams, Client) ->
      $scope.form = new Client(name: '', email: '')
      $scope.processing = false
      $scope.init = true
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.client.$valid
          $scope.processing = true
          $scope.form.$save ->
            $state.go 'auth.clients.index'

  ]

