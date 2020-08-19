# SimpleRESTRequest
Biblioteca para Requisições REST de forma simples no Delphi

```delphi
uses 
  SimpleRestRequest,
  SimpleRestRequest.Interfaces;

var
  LRequest: iSimpleRestResquest;
begin
  LRequest := TSimpleRestRequest.New
    .BaseURL('http://seusite.com')
    .ContentType('application/json')
    .Get;
  
  if LRequest.StatusCode = 200 then
    Result := LRequest.Return; // JSON
end;
```

