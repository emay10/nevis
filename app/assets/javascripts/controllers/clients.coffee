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
    'Policy'
    'User'
    ($scope, $state, $stateParams, Client, Policy, User) ->
      $scope.form = new Client(name: '', email: '', status: 'active')
      $scope.processing = false
      $scope.init = true
      Policy.query (res) ->
        $scope.policies = res
        User.query (res) ->
          $scope.users = res
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.client.$valid
          $scope.processing = true
          $scope.form.$save ->
            $state.go 'auth.clients.index'
  ]

  .controller 'clientsEditController', [
    '$scope'
    '$state'
    '$stateParams'
    'Client'
    'Policy'
    'User'
    ($scope, $state, $stateParams, Client, Policy, User) ->
      client_id = $stateParams.id
      Policy.query (res) ->
        $scope.policies = res
        User.query (res) ->
          $scope.users = res
          Client.get id: client_id, (res) ->
            $scope.form = res
      $scope.processing = false
      $scope.init = true
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.client.$valid
          $scope.processing = true
          $scope.form.$update id: $scope.form.id, ->
            $state.go 'auth.clients.index'
  ]

