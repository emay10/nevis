angular
  .module 'nscom.controllers.users', []

  .controller 'usersSignInController', [
    '$scope'
    '$auth'
    '$window'
    '$state'
    '$stateParams'
    '$rootScope'
    'User'
    ($scope, $auth, $window, $state, $stateParams, $rootScope, User) ->
      $scope.processing = false
      $scope.init = true
      $scope.form =
        email: ''
        password: ''
      success_handler = ->
        User.current (res) -> $rootScope.current_user = res
        $state.go 'auth.static.dashboard'
      $scope.authenticate = (provider) ->
        $auth.authenticate(provider, provider: provider).then success_handler
      $scope.signIn = ->
        $scope.errors = []
        $scope.init = false
        if $scope.sign_in.$valid
          $scope.processing = true
          $auth
            .login(auth: $scope.form)
            .then success_handler
            .catch (res) ->
              if res.status in [401, 404]
                $scope.errors.push 'Invalid credentials'
              else
                $scope.errors.push 'Something went wrong'
            .finally -> $scope.processing = false
  ]

  .controller 'usersSignUpController', [
    '$scope'
    '$auth'
    '$state'
    '$window'
    '$rootScope'
    'User'
    ($scope, $auth, $state, $window, $rootScope, User) ->
      $scope.processing = false
      $scope.init = true
      $scope.form =
        email: ''
        password: ''
        password_confirmation: ''
      $scope.signUp = ->
        $scope.errors = []
        $scope.init = false
        success_handler = ->
          User.current (res) -> $rootScope.current_user = res
          $state.go 'auth.static.dashboard'
        if $scope.sign_up.$valid
          $scope.processing = true
          $auth
            .signup($scope.form)
            .then (res) ->
              $auth.login(auth: $scope.form).then success_handler
            .catch (res) ->
              if res.status in [401, 409, 412]
                $scope.errors.push 'A user with the provided credentials already exists in the system'
              else
                $scope.errors.push 'Something went wrong'
            .finally -> $scope.processing = false
  ]

  .controller 'usersIndexController', [
    '$scope'
    '$state'
    '$stateParams'
    'User'
    ($scope, $state, $stateParams, User) ->
      $scope.remove = (id) ->
        user = new User(id: id)
        if user
          user.$remove id: id, ->
            $scope.users = $scope.users.filter (e) -> e.id != id
      User.query (res) ->
        $scope.users = res
  ]

  .controller 'usersNewController', [
    '$scope'
    '$state'
    '$stateParams'
    'User'
    'Agency'
    ($scope, $state, $stateParams, User, Agency) ->
      $scope.form = new User(name: '', email: '', commission: '', password: '', password_confirmation: '')
      $scope.processing = false
      $scope.init = true
      User.query (res) ->
        $scope.users = res
      Agency.query (res) ->
        $scope.agencies = res
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.user.$valid
          $scope.processing = true
          $scope.form.$save ->
            $state.go 'auth.users.index'
  ]

  .controller 'usersEditController', [
    '$scope'
    '$state'
    '$stateParams'
    'User'
    'Agency'
    ($scope, $state, $stateParams, User, Agency) ->
      user_id = $stateParams.id
      Agency.query (res) ->
        $scope.agencies = res
        User.get id: user_id, (res) ->
          $scope.form = res
      $scope.processing = false
      $scope.init = true
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.user.$valid
          $scope.processing = true
          $scope.form.$update id: $scope.form.id, ->
            $state.go 'auth.users.index'
    ]

  .controller 'agenciesIndexController', [
    '$scope'
    '$state'
    '$stateParams'
    'Agency'
    ($scope, $state, $stateParams, Agency) ->
      $scope.remove = (id) ->
        agency = new Agency(id: id)
        if agency
          agency.$remove id: id, ->
            $scope.agencies = $scope.agencies.filter (e) -> e.id != id
      Agency.query (res) ->
        $scope.agencies = res
  ]

  .controller 'agenciesNewController', [
    '$scope'
    '$state'
    '$stateParams'
    'Agency'
    ($scope, $state, $stateParams, Agency) ->
      $scope.form = new Agency(name: '')
      $scope.processing = false
      $scope.init = true
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.agency.$valid
          $scope.processing = true
          $scope.form.$save ->
            $state.go 'auth.agencies.index'
  ]

.controller 'agenciesEditController', [
    '$scope'
    '$state'
    '$stateParams'
    'Agency'
    ($scope, $state, $stateParams, Agency) ->
      agency_id = $stateParams.id
      Agency.query (res) ->
        Agency.get id: agency_id, (res) ->
          $scope.form = res
      $scope.processing = false
      $scope.init = true
      $scope.submit = ->
        $scope.errors = []
        $scope.init = false
        if $scope.agency.$valid
          $scope.processing = true
          $scope.form.$update id: $scope.form.id, ->
            $state.go 'auth.agencies.index'
    ]


