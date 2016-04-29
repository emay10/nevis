angular
  .module 'nscom.controllers.commissions', []

  .controller 'commissionsIndexController', [
    '$scope'
    '$state'
    '$stateParams'
    'Commission'
    ($scope, $state, $stateParams, Commission) ->
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
    ($scope, $state, $stateParams, Commission, Client) ->
      $scope.form = new Commission(client_id: '', policy_id: '', user_id: '', amount: '')
      $scope.processing = false
      $scope.init = true
      Client.query (res) ->
        $scope.clients = res
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.commission.$valid
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
    ($scope, $state, $stateParams, Commission, Client) ->
      $scope.init = true
      commission_id = $stateParams.id
      Client.query (res) ->
        $scope.clients = res
        Commission.get id: commission_id, (res) ->
          $scope.form = res
      $scope.processing = false
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.commission.$valid
          $scope.processing = true
          $scope.form.$update id: $scope.form.id, ->
            $state.go 'auth.commissions.index'

  ]
