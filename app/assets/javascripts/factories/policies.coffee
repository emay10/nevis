angular.module 'nscom.factories.policies', []
  .factory 'Policy', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'policies/:id.json', {},
        query:
          #vulnerable
          isArray: true
        save:
          method: 'POST'
          url: API_URL + 'policies.json'
  ]
