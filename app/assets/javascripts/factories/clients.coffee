angular.module 'nscom.factories.clients', []
  .factory 'Client', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'clients/:id.json', {},
        query:
          #vulnerable
          isArray: true
        save:
          method: 'POST'
          url: API_URL + 'clients.json'
  ]
