angular
  .module 'nscom.controllers.commissions', []

  .controller 'commissionsIndexController', [
    '$scope'
    '$state'
    '$stateParams'
    'Commission'
    'Client'
    ($scope, $state, $stateParams, Commission, Client) ->
      $scope.remove = (id) ->
        commission = new Commission(id: id)
        if commission
          commission.$remove id: id, ->
            $scope.commissions = $scope.commissions.filter (e) -> e.id != id

      Commission.query (res) ->
        $scope.commissions = res
  ]

  .controller 'commissionsNewController', [
    '$scope'
    '$state'
    '$stateParams'
    'Commission'
    'Client'
    'Policy'
    'User'
    ($scope, $state, $stateParams, Commission, Client, Policy, User) ->
      $scope.form = new Commission(client_id: 0, policy_id: 0, user_id: 0, amount: '')
      $scope.processing = false
      $scope.init = true
      Client.query (res) ->
        $scope.clients = res
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
            $state.go 'auth.commissions.index'

  ]

  .controller 'commissionsEditController', [
    '$scope'
    '$state'
    '$stateParams'
    'Commission'
    'Client'
    'Policy'
    'User'
    ($scope, $state, $stateParams, Commission, Client, Policy, User) ->
      $scope.init = true
      Client.query (res) ->
        $scope.clients = res
        Policy.query (res) ->
          $scope.policies = res
          User.query (res) ->
            $scope.users = res
            commission_id = $stateParams.id
            Commission.get id: commission_id, (res) ->
              $scope.form = res
      $scope.processing = false
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.client.$valid
          $scope.processing = true
          $scope.form.$update id: $scope.form.id, ->
            $state.go 'auth.commissions.index'

  ]
