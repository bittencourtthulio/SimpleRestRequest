# SimpleRESTRequest
Biblioteca para Requisições REST de forma simples no Delphi

```delphi
uses
  SimpleRestRequest;

  
  TSimpleRestRequest
      .New
        .BaseURL('http://seusite.com')
        .ContentType('application/json')
      .Get
      .Return
```

