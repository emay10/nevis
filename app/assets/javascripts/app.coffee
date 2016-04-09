angular.module 'nscom', [
  'ui.router'
  'ngResource'
  'satellizer'
  #'angularFileUpload'
  'ui.bootstrap'
  #'infinite-scroll'
  #'LocalStorageModule'
  'nscom.controllers.users'
  'nscom.controllers.clients'
  'nscom.controllers.static'
  'nscom.factories.users'
  'nscom.factories.clients'
  'templates'
]

angular.module 'nscom'

  .constant 'API_URL', '/api/'

  .config [
    '$stateProvider'
    '$urlRouterProvider'
    '$locationProvider'
    '$authProvider'
    '$httpProvider'
    ($stateProvider, $urlRouterProvider, $locationProvider, $authProvider, $httpProvider) ->
      $urlRouterProvider.otherwise '/'
      $locationProvider.html5Mode true
      $authProvider.tokenName = 'jwt'
      $authProvider.loginUrl = '/api/auth/auth_token'
      $authProvider.signupUrl = '/api/auth'

      $stateProvider
        .state 'users',
          abstract: true
          template: '<ui-view/>'
          controller: [
            '$auth'
            '$state'
            ($auth, $state) ->
              if $auth.isAuthenticated()
                $state.go 'auth.static.dashboard'
          ]
        .state 'users.signin',
          url: '/signin'
          templateUrl: 'users/sign_in.html'
          controller: 'usersSignInController'
        .state 'users.signup',
          url: '/signup'
          templateUrl: 'users/sign_up.html'
          controller: 'usersSignUpController'
        .state 'auth',
          abstract: true
          template: '<ui-view/>'
          controller: [
            '$auth'
            '$state'
            ($auth, $state) ->
              unless $auth.isAuthenticated()
                $state.go 'users.signin'
          ]
        .state 'auth.users',
          abstract: true
          template: '<ui-view/>'
        .state 'auth.users.signout',
          url: '/users/signout'
          controller: [
            '$auth'
            '$state'
            '$rootScope'
            ($auth, $state, $rootScope) ->
              $auth.logout().then ->
                $rootScope.current_user = null
                $state.go 'users.signin'
          ]
        .state 'auth.users.edit',
          url: '/users/edit'
          templateUrl: 'users/edit.html'
          controller: 'usersEditController'
        .state 'auth.users.show',
          url: '/users/:id'
          templateUrl: 'users/show.html'
          controller: 'usersShowController'
        .state 'auth.static',
          abstract: true
          template: '<ui-view/>'
        .state 'auth.static.dashboard',
          url: '/'
          templateUrl: 'static/dashboard.html'
          controller: 'staticDashboardController'
        .state 'auth.clients',
          abstract: true
          template: '<ui-view/>'
        .state 'auth.clients.new',
          url: '/clients/new'
          templateUrl: 'clients/new.html'
          controller: 'clientsNewController'
        .state 'auth.clients.index',
          url: '/clients'
          templateUrl: 'clients/index.html'
          controller: 'clientsIndexController'

      # converting json object payload to form-urlencoded string
      #$httpProvider.defaults.headers.post["Content-Type"] = "application/x-www-form-urlencoded";
      #$httpProvider.defaults.transformRequest.unshift (data, headersGetter) ->
      #  key = []
      #  result = []
      #  for key of data
      #    if data.hasOwnProperty(key)
      #      result.push(encodeURIComponent(key) + "=" + encodeURIComponent(data[key]))
      #  return result.join("&");
  ]

  .run [
    '$rootScope'
    '$auth'
    '$state'
    '$window'
    'User'
    ($rootScope, $auth, $state, $window, User) ->
      if $auth.isAuthenticated()
        User.current(
          (res) -> $rootScope.current_user = res,
          (err) -> $state.go 'auth.users.signout'
        )

  ]
