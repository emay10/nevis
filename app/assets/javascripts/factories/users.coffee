angular.module 'nscom.factories.users', []
  .factory 'User', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'users/:id', {},
        save:
          method: 'PUT'
          url: API_URL + 'users'
        current:
          isArray: false
          url: API_URL + 'users/current'
  ]
