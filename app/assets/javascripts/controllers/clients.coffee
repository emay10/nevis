angular
  .module 'nscom.controllers.clients', []

  .controller 'clientsIndexController', [
    '$scope'
    '$state'
    '$stateParams'
    'Client'
    ($scope, $state, $stateParams, Client) ->
      $scope.remove = (id) ->
        client = new Client(id: id)
        if client
          client.$remove id: id, ->
            $scope.clients = $scope.clients.filter (e) -> e.id != id
      Client.query (res) ->
        $scope.clients = res
  ]

  .controller 'clientsNewController', [
    '$scope'
    '$state'
    '$stateParams'
    'Client'
    ($scope, $state, $stateParams, Client) ->
      $scope.form = new Client(name: '', email: '', status: 'active')
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

