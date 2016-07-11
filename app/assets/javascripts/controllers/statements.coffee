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
      $scope.updateStatus = (statement) ->
        statement.$update(id: statement.id)
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
      $scope.selection = []
      $scope.form = new Statement(users: '', month: '', year: '')
      $scope.processing = false
      $scope.init = true
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.statement.$valid and $scope.selection.length > 0
          $scope.form.users = $scope.selection.join(',')
          #$scope.processing = true
          $scope.form.$save ->
            $state.go 'auth.statements.index'
      $scope.toggleSelection = (id) ->
        idx = $scope.selection.indexOf(id)
        if idx != -1
          $scope.selection.splice(idx, 1)
        else
          $scope.selection.push(id)
  ]

  .controller 'statementsShowController', [
    '$scope'
    '$state'
    '$stateParams'
    'Statement'
    ($scope, $state, $stateParams, Statement) ->
      statement_id = $stateParams.id
      Statement.get id: statement_id, (res) ->
        $scope.statement = res
        $scope.commissions = res.commissions
  ]
