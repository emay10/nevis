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

  .controller 'commissionsImportController', [
    '$scope'
    '$state'
    '$stateParams'
    'Commission'
    'Upload'
    ($scope, $state, $stateParams, Commission, Upload) ->
      $scope.init = true
      $scope.processing = false
      $scope.upload = (file) ->
        Upload.upload(
          url: 'api/commissions/import',
          data: {file: file}
        ).then(
          (resp) -> $state.go 'auth.commissions.index', 
          (resp) -> $scope.text = 'Error status: ' + resp.status,
          (evt) ->
            $scope.init = false
            progressPercentage = parseInt(100.0 * evt.loaded / evt.total)
            $scope.text = 'Upload progress: ' + progressPercentage + '% '
        )
  ]


