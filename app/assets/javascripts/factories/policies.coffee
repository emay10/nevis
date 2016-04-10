angular.module 'nscom.factories.policies', []
  .factory 'Policy', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'policies/:id', {},
        query:
          #vulnerable
          isArray: true
        update:
          method: 'PATCH'
          url: API_URL + 'policies/:id'
        save:
          method: 'POST'
          url: API_URL + 'policies'
  ]
