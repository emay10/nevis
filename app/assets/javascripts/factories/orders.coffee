angular.module 'nscom.factories.orders', []
  .factory 'Order', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'orders/:id', {},
        remove:
          method: 'DELETE'
          url: API_URL + 'orders/:id'
        update:
          method: 'PATCH'
          url: API_URL + 'orders/:id'
        query:
          #vulnerable
          isArray: true
        save:
          method: 'POST'
          url: API_URL + 'orders'
  ]
