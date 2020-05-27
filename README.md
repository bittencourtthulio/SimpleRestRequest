# SimpleRESTRequest
Biblioteca para Requisições REST de forma simples no Delphi

```delphi
uses
  SimpleRestRequest;

  
  TSimpleRestRequest
      .New
        .BaseURL('')
        .AddHeaders('wsc-api-key', FParent.APIKey)
        .AddHeaders('wsc-access-key', FParent.AccessKey)
        .ContentType('application/json')
      .Get
      .Return
```

