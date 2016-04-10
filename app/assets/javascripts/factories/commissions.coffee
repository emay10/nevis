angular.module 'nscom.factories.commissions', []
  .factory 'Commission', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'commissions/:id.json', {},
        query:
          #vulnerable
          isArray: true
        save:
          method: 'POST'
          url: API_URL + 'commissions.json'
  ]
