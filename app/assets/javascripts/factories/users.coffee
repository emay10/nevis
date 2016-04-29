angular.module 'nscom.factories.users', []
  .factory 'User', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'users/:id', {},
        remove:
          method: 'DELETE'
          url: API_URL + 'users/:id'
        update:
          method: 'PATCH'
          url: API_URL + 'users/:id'
        query:
          #vulnerable
          isArray: true
        save:
          method: 'POST'
          url: API_URL + 'users'
        current:
          isArray: false
          url: API_URL + 'users/current'
  ]

  .factory 'Agency', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'agencies/:id', {},
        remove:
          method: 'DELETE'
          url: API_URL + 'agencies/:id'
        update:
          method: 'PATCH'
          url: API_URL + 'agencies/:id'
        query:
          #vulnerable
          isArray: true
        save:
          method: 'POST'
          url: API_URL + 'agencies'
  ]
