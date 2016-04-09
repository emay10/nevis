angular.module 'nscom.factories.users', []
  .factory 'User', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'users/:id', {},
        query:
          isArray: false
        save:
          method: 'PUT'
          url: API_URL + 'user'
        current:
          isArray: false
          url: API_URL + 'users/current.json'
  ]
