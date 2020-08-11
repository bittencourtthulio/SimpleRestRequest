unit SimpleRestRequest;

interface

uses
  SimpleRestRequest.Interfaces,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  System.JSON,
  System.Classes;

type
  TSimpleRestRequest = class(TInterfacedObject, iSimpleRestResquest)
    private
      FIdHTTP : TIdHTTP;
      FBaseURL : String;
      FStreamSend : TStringStream;
      FReturn : String;
      function IsBasicAuthentication : Boolean;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iSimpleRestResquest;
      function StatusCode : Integer;
      function Password ( aValue : string) : iSimpleRestResquest;
      function Username ( aValue : string) : iSimpleRestResquest;
      function AddHeaders ( aKey : String; aValue : String) : iSimpleRestResquest;
      function ContentType (aValue : String) : iSimpleRestResquest;
      function Connection (aValue : String) : iSimpleRestResquest;
      function UserAgent (aValue : String) : iSimpleRestResquest;
      function HandleRedirects ( aValue : Boolean ) : iSimpleRestResquest;
      function BaseURL (aValue : String) : iSimpleRestResquest;
      function Body (aValue : String)  : iSimpleRestResquest; overload;
      function Body (aValue : TJsonObject) : iSimpleRestResquest; overload;
      function Post : iSimpleRestResquest;
      function Get : iSimpleRestResquest;
      function Delete : iSimpleRestResquest;
      function Put : iSimpleRestResquest;
      function Return : String;
  end;

implementation

{ TSimpleRestRequest }

function TSimpleRestRequest.AddHeaders(aKey,
  aValue: String): iSimpleRestResquest;
begin
  Result := Self;
  FIdHTTP.Request.CustomHeaders.AddValue(aKey, aValue);
end;

function TSimpleRestRequest.BaseURL(aValue: String): iSimpleRestResquest;
begin
  Result := Self;
  FBaseURL := aValue;
end;

function TSimpleRestRequest.Body(aValue: String): iSimpleRestResquest;
begin
  Result := Self;
  FStreamSend := TStringStream.Create(aValue);
end;

function TSimpleRestRequest.Body(aValue: TJsonObject): iSimpleRestResquest;
begin
  Result := Self;
  FStreamSend := TStringStream.Create(aValue.ToJSON);
end;

function TSimpleRestRequest.Connection(aValue: String): iSimpleRestResquest;
begin
  Result := Self;
  FIdHTTP.Request.Connection := aValue;
end;

function TSimpleRestRequest.ContentType(aValue: String): iSimpleRestResquest;
begin
  Result := Self;
  FIdHTTP.Request.ContentType := aValue;
end;

constructor TSimpleRestRequest.Create;
begin
  FIdHTTP := TIdHTTP.Create(nil);
  FIdHTTP.Request.Connection := 'Keep-Alive';
  FIdHTTP.Request.UserAgent := 'User-Agent:Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.96 Safari/537.36';
  FIdHTTP.HandleRedirects := true;
end;

function TSimpleRestRequest.Delete: iSimpleRestResquest;
var
  FStreamResult : TStringStream;
begin
  Result := Self;
  FStreamResult := TStringStream.Create;
  try
    FIdHTTP.Delete(FBaseURL, FStreamResult);
    FReturn := FStreamResult.DataString;
  finally
    FStreamResult.Free;
  end;
end;

destructor TSimpleRestRequest.Destroy;
begin
  if Assigned(FStreamSend) then
     FStreamSend.Free;

  FIdHTTP.Free;
  inherited;
end;

function TSimpleRestRequest.Get: iSimpleRestResquest;
var
  FStreamResult : TStringStream;
begin
  Result := Self;
  FStreamResult := TStringStream.Create;
  try
    FIdHTTP.Get(FBaseURL, FStreamResult);
    FReturn := FStreamResult.DataString;
  finally
    FStreamResult.Free;
  end;
end;

function TSimpleRestRequest.HandleRedirects(
  aValue: Boolean): iSimpleRestResquest;
begin
  Result := Self;
  FIdHTTP.HandleRedirects := aValue;
end;

function TSimpleRestRequest.IsBasicAuthentication: Boolean;
begin
  Result := (FIdHTTP.Request.Password <> '') and (FIdHTTP.Request.Username <> '');
end;

class function TSimpleRestRequest.New: iSimpleRestResquest;
begin
    Result := Self.Create;
end;

function TSimpleRestRequest.Password(aValue: string): iSimpleRestResquest;
begin
  Result := Self;
  FIdHTTP.Request.Password := aValue;
  FIdHTTP.Request.BasicAuthentication := IsBasicAuthentication;
end;

function TSimpleRestRequest.Post: iSimpleRestResquest;
begin
  Result := Self;
  FReturn := FIdHTTP.Post(FBaseURL, FStreamSend);
end;

function TSimpleRestRequest.Put: iSimpleRestResquest;
var
  FStreamResult : TStringStream;
begin
  Result := Self;
  FStreamResult := TStringStream.Create;
  try
    if not Assigned(FStreamSend) then
      FStreamSend := TStringStream.Create;

    FIdHTTP.Put(FBaseURL, FStreamSend, FStreamResult);
    FReturn := FStreamResult.DataString;

  finally
    FStreamResult.Free;
  end;

end;

function TSimpleRestRequest.Return: String;
begin
  Result := FReturn;
end;

function TSimpleRestRequest.StatusCode: Integer;
begin
  Result := FIdHTTP.ResponseCode;
end;

function TSimpleRestRequest.UserAgent(aValue: String): iSimpleRestResquest;
begin
  Result := Self;
  FIdHTTP.Request.UserAgent := aValue;
end;

function TSimpleRestRequest.Username(aValue: string): iSimpleRestResquest;
begin
  Result := Self;
  FIdHTTP.Request.Username := aValue;
  FIdHTTP.Request.BasicAuthentication := IsBasicAuthentication;
end;

end.
