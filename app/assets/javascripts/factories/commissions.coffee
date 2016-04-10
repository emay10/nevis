angular.module 'nscom.factories.commissions', []
  .factory 'Commission', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'commissions/:id', {},
        remove:
          method: 'DELETE'
          url: API_URL + 'commissions/:id'
        update:
          method: 'PATCH'
          url: API_URL + 'commissions/:id'
        query:
          #vulnerable
          isArray: true
        save:
          method: 'POST'
          url: API_URL + 'commissions'
  ]
