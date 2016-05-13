angular
  .module 'nscom.controllers.clients', []

  .controller 'clientsIndexController', [
    '$scope'
    '$state'
    '$stateParams'
    'Client'
    ($scope, $state, $stateParams, Client) ->
      $scope.search =
        field: ''
        query: ''
      $scope.remove = (id) ->
        client = new Client(id: id)
        if client
          client.$remove id: id, ->
            $scope.clients = $scope.clients.filter (e) -> e.id != id
      Client.query (res) ->
        $scope.original = res
        $scope.clients = res
      $scope.filter = ->
        search = $scope.search
        if search.field.length > 0 and search.query.length > 0
          $scope.clients = $scope.original.filter (e) ->
            nested = search.field.indexOf('.') != -1
            if nested
              keys = search.field.split('.')
              ob = e[keys[0]]
              if ob
                val = ob[keys[1]]
              else
                val = false
            else
              val = e[search.field]
            if val
              val = String(val).toLowerCase()
              val.indexOf(search.query.toLowerCase()) != -1
        else
          $scope.clients = $scope.original
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

