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
    ($scope, $auth, $state, $window) ->
      $scope.processing = false
      $scope.init = true
      $scope.form =
        email: ''
        name: ''
        phone: ''
        provider: 'phone'
        token: ''
        token_confirmation: ''
      $scope.signUp = ->
        $scope.errors = []
        $scope.init = false
        if $scope.sign_up.$valid
          $scope.processing = true
          $auth
            .signup($scope.form)
            .then (res) ->
              if code and code.length > 0
                $window.location = $state.get('albums.join').url.replace(':code', code)
              else
                $window.location = $state.get('auth.albums.private').url
            .catch (res) ->
              if res.status in [401, 409, 412]
                $scope.errors.push 'A user with the provided credentials already exists in the system'
              else
                $scope.errors.push 'Something went wrong'
            .finally -> $scope.processing = false
  ]

  .controller 'usersEditController', [
    '$scope'
    '$upload'
    'User'
    '$state'
    '$window'
    'API_URL'
    ($scope, $upload, User, $state, $window, API_URL) ->
      $scope.processing = false
      $scope.init = true
      $scope.$watch 'user', (user) ->
        if user
          $scope.provider = null
          if user.fb_id
            $scope.provider = 'facebook'
          else if user.google_id
            $scope.provider = 'google'
          $scope.data = new User
            email: user.email,
            name: user.name,
            phone: user.phone,
            profile_picture: user.profile_picture
            #token: '',
            #token_confirmation: ''

          $scope.grabPhoto = ->
            if $scope.provider
              $scope.errors = []
              $scope.notices = []
              User.fetchPicture provider: $scope.provider,
                (->
                  $scope.notices.push 'Profile was successfully updated'
                  $window.setTimeout (-> $window.location.reload()), 1000
                ),
                (-> $scope.errors.push 'Something went wrong')

      $scope.$watch 'file', -> $scope.upload $scope.file if $scope.file
      $scope.upload = (file) ->
        $scope.errors = []
        $scope.notices = []
        $scope.processing = true
        file.progress = 0
        file.success = true
        $upload.upload
          url: "#{API_URL}user/picture"
          fileFormDataName: 'picture'
          file: file
        .progress (evt) ->
          total = parseInt 100.0 * evt.loaded / evt.total
          if file.progress < total
            if total < 100
              file.progress = total
            else
              file.progress = 99
        .success (data, status, headers, config) ->
          $scope.notices.push 'Profile was successfully updated'
          $window.setTimeout (-> $window.location.reload()), 1000
          $scope.processing = false
        .error (data, status, headers, config) ->
          file.success = false
          $scope.processing = false
          $scope.notices.push 'Something went wrong'
      $scope.submit = ->
        $scope.errors = []
        $scope.notices = []
        $scope.init = false
        if $scope.form.$valid
          $scope.processing = true
          $scope.data.$save()
            .then (res) ->
              $scope.notices.push 'Profile was successfully updated'
            .catch (res) ->
              $scope.errors.push 'Something went wrong'
            .finally -> $scope.processing = false
  ]
