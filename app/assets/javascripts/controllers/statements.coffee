angular
  .module 'nscom.controllers.statements', []

  .controller 'statementsIndexController', [
    '$scope'
    '$state'
    '$stateParams'
    'Statement'
    ($scope, $state, $stateParams, Statement) ->
      Statement.query (res) ->
        $scope.statements = res
      $scope.remove = (id) ->
        statement = new Statement(id: id)
        if statement
          statement.$remove id: id, ->
            $scope.statements = $scope.statements.filter (e) -> e.id != id
  ]

  .controller 'statementsNewController', [
    '$scope'
    '$state'
    '$stateParams'
    'Statement'
    'User'
    ($scope, $state, $stateParams, Statement, User) ->
      $scope.users = User.query()
      $scope.form = new Statement(user_id: '', date: '')
      $scope.processing = false
      $scope.init = true
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.statement.$valid
          $scope.processing = true
          $scope.form.$save ->
            $state.go 'auth.statements.index'
  ]
