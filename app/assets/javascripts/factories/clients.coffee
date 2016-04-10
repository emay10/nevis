angular.module 'nscom.factories.clients', []
  .factory 'Client', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'clients/:id', {},
        remove:
          method: 'DELETE'
          url: API_URL + 'clients/:id'
        query:
          #vulnerable
          isArray: true
        save:
          method: 'POST'
          url: API_URL + 'clients'
  ]
