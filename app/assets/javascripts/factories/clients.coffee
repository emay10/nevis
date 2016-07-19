angular.module 'nscom.factories.clients', []
  .factory 'Client', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'clients/:id', {},
        remove:
          method: 'DELETE'
          url: API_URL + 'clients/:id'
        update:
          method: 'PATCH'
          url: API_URL + 'clients/:id'
        query:
          #vulnerable
          isArray: true
        pdf:
          url: API_URL + 'clients/pdf'
        xls:
          url: API_URL + 'clients/xls'
        save:
          method: 'POST'
          url: API_URL + 'clients'
  ]
