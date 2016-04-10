angular
  .module 'nscom.controllers.policies', []

  .controller 'policiesIndexController', [
    '$scope'
    '$state'
    '$stateParams'
    'Policy'
    ($scope, $state, $stateParams, Policy) ->
      $scope.remove = (id) ->
        policy = new Policy(id: id)
        if policy
          policy.$remove id: id, ->
            $scope.policies = $scope.policies.filter (e) -> e.id != id

      Policy.query (res) ->
        $scope.policies = res
  ]

  .controller 'policiesNewController', [
    '$scope'
    '$state'
    '$stateParams'
    'Policy'
    ($scope, $state, $stateParams, Policy) ->
      $scope.form = new Policy(name: '', carrier: '', kind: 'medical', commission: '')
      $scope.processing = false
      $scope.init = true
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.policy.$valid
          $scope.processing = true
          $scope.form.$save ->
            $state.go 'auth.policies.index'
  ]

  .controller 'policiesEditController', [
    '$scope'
    '$state'
    '$stateParams'
    'Policy'
    ($scope, $state, $stateParams, Policy) ->
      $scope.init = true
      policy_id = $stateParams.id
      Policy.get id: policy_id, (res) ->
        $scope.form = res
      $scope.processing = false
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.policy.$valid
          $scope.processing = true
          $scope.form.$update id: $scope.form.id, ->
            $state.go 'auth.policies.index'
  ]
