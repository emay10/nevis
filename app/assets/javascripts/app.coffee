angular.module 'nscom', [
  'ui.router'
  'ngResource'
  'satellizer'
  'ngFileUpload'
  'ui.bootstrap'
  'tableSort'
  'stripe.checkout'
  'nscom.controllers.users'
  'nscom.controllers.clients'
  'nscom.controllers.commissions'
  'nscom.controllers.statements'
  'nscom.controllers.policies'
  'nscom.controllers.static'
  'nscom.controllers.payments'
  'nscom.factories.users'
  'nscom.factories.clients'
  'nscom.factories.commissions'
  'nscom.factories.policies'
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
        .state 'auth.users.new',
          url: '/users/new'
          templateUrl: 'users/new.html'
          controller: 'usersNewController'
        .state 'auth.users.edit',
          url: '/users/:id/edit'
          templateUrl: 'users/edit.html'
          controller: 'usersEditController'
        .state 'auth.users.show',
          url: '/users/:id'
          templateUrl: 'users/show.html'
          controller: 'usersShowController'
        .state 'auth.users.index',
          url: '/users'
          templateUrl: 'users/index.html'
          controller: 'usersIndexController'
        .state 'auth.payments',
          abstract: true
          template: '<ui-view/>'
        .state 'auth.payments.new',
          url: '/payments'
          templateUrl: 'payments/index.html'
          controller: 'paymentsNewController'
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
        .state 'auth.clients.edit',
          url: '/clients/:id/edit'
          templateUrl: 'clients/edit.html'
          controller: 'clientsEditController'
        .state 'auth.clients.new',
          url: '/clients/new'
          templateUrl: 'clients/new.html'
          controller: 'clientsNewController'
        .state 'auth.clients.index',
          url: '/clients'
          templateUrl: 'clients/index.html'
          controller: 'clientsIndexController'
        .state 'auth.policies',
          abstract: true
          template: '<ui-view/>'
        .state 'auth.policies.edit',
          url: '/policies/:id/edit'
          templateUrl: 'policies/edit.html'
          controller: 'policiesEditController'
        .state 'auth.policies.new',
          url: '/policies/new'
          templateUrl: 'policies/new.html'
          controller: 'policiesNewController'
        .state 'auth.policies.index',
          url: '/policies'
          templateUrl: 'policies/index.html'
          controller: 'policiesIndexController'
        .state 'auth.commissions',
          abstract: true
          template: '<ui-view/>'
        .state 'auth.commissions.edit',
          url: '/commissions/:id/edit'
          templateUrl: 'commissions/edit.html'
          controller: 'commissionsEditController'
        .state 'auth.commissions.import',
          url: '/commissions/import'
          templateUrl: 'commissions/import.html'
          controller: 'commissionsImportController'
        .state 'auth.commissions.new',
          url: '/commissions/new'
          templateUrl: 'commissions/new.html'
          controller: 'commissionsNewController'
        .state 'auth.commissions.index',
          url: '/commissions'
          templateUrl: 'commissions/index.html'
          controller: 'commissionsIndexController'
        .state 'auth.statements',
          abstract: true
          template: '<ui-view/>'
        .state 'auth.statements.new',
          url: '/statements/new'
          templateUrl: 'statements/new.html'
          controller: 'statementsNewController'
        .state 'auth.statements.show',
          url: '/statements/:id'
          templateUrl: 'statements/show.html'
          controller: 'statementsShowController'
        .state 'auth.statements.index',
          url: '/statements'
          templateUrl: 'statements/index.html'
          controller: 'statementsIndexController'
        .state 'auth.agencies',
          abstract: true
          template: '<ui-view/>'
        .state 'auth.agencies.edit',
          url: '/agencies/:id/edit'
          templateUrl: 'agencies/edit.html'
          controller: 'agenciesEditController'
        .state 'auth.agencies.new',
          url: '/agencies/new'
          templateUrl: 'agencies/new.html'
          controller: 'agenciesNewController'
        .state 'auth.agencies.index',
          url: '/agencies'
          templateUrl: 'agencies/index.html'
          controller: 'agenciesIndexController'



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
