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
        pdf:
          url: API_URL + 'commissions/pdf'
        xls:
          url: API_URL + 'commissions/xls'
  ]

  .factory 'Statement', [
    '$resource',
    'API_URL',
    ($resource, API_URL) ->
      $resource API_URL + 'statements/:id', {},
        remove:
          method: 'DELETE'
          url: API_URL + 'statements/:id'
        update:
          method: 'PATCH'
          url: API_URL + 'statements/:id'
        query:
          #vulnerable
          isArray: true
        save:
          method: 'POST'
          url: API_URL + 'statements'
        pdf:
          url: API_URL + 'statements/:id/pdf'
        xls:
          url: API_URL + 'statements/:id/xls'
  ]
