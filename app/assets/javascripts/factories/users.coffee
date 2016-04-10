angular.module 'nscom.factories.users', []
  .factory 'User', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'users/:id.json', {},
        save:
          method: 'PUT'
          url: API_URL + 'users.json'
        current:
          isArray: false
          url: API_URL + 'users/current.json'
  ]
