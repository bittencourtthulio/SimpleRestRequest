unit SimpleRestRequest;

interface

uses
  SimpleRestRequest.Interfaces,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  IdSSLOpenSSL,
  {$IF CompilerVersion > 22}System.JSON,{$ELSE} JsonDataObjects,{$IFEND}
  {$IF CompilerVersion > 22}System.{$IFEND}Classes;

type
  TSimpleRestRequest = class(TInterfacedObject, iSimpleRestRequest)
    private
      FIdHTTP : TIdHTTP;
      FIdSSLIOHandlerSocket: TIdSSLIOHandlerSocketOpenSSL;
      FBaseURL : String;
      FStreamSend : TStringStream;
      FReturn : String;
      function IsBasicAuthentication : Boolean;
    public
      constructor Create;
      destructor Destroy; override;
      class function New : iSimpleRestRequest;
      function StatusCode : Integer;
      function Password ( aValue : string) : iSimpleRestRequest;
      function Username ( aValue : string) : iSimpleRestRequest;
      function IOHandler( aValue : TIdSSLIOHandlerSocketOpenSSL) : iSimpleRestRequest;
      function AddHeaders ( aKey : String; aValue : String) : iSimpleRestRequest;
      function ContentType (aValue : String) : iSimpleRestRequest;
      function Connection (aValue : String) : iSimpleRestRequest;
      function UserAgent (aValue : String) : iSimpleRestRequest;
      function HandleRedirects ( aValue : Boolean ) : iSimpleRestRequest;
      function BaseURL (aValue : String) : iSimpleRestRequest;
      function Body (aValue : String)  : iSimpleRestRequest; overload;
      function Body (aValue : TJsonObject) : iSimpleRestRequest; overload;
      function Post : iSimpleRestRequest;
      function Get : iSimpleRestRequest;
      function Delete : iSimpleRestRequest;
      function Put : iSimpleRestRequest;
      function Return : String;
  end;

implementation

{ TSimpleRestRequest }

function TSimpleRestRequest.AddHeaders(aKey,
  aValue: String): iSimpleRestRequest;
begin
  Result := Self;
  FIdHTTP.Request.CustomHeaders.AddValue(aKey, aValue);
end;

function TSimpleRestRequest.BaseURL(aValue: String): iSimpleRestRequest;
begin
  Result := Self;
  FBaseURL := aValue;
end;

function TSimpleRestRequest.Body(aValue: String): iSimpleRestRequest;
begin
  Result := Self;
  FStreamSend := TStringStream.Create(aValue);
end;

function TSimpleRestRequest.Body(aValue: TJsonObject): iSimpleRestRequest;
begin
  Result := Self;
  FStreamSend := TStringStream.Create(aValue.ToJSON);
end;

function TSimpleRestRequest.Connection(aValue: String): iSimpleRestRequest;
begin
  Result := Self;
  FIdHTTP.Request.Connection := aValue;
end;

function TSimpleRestRequest.ContentType(aValue: String): iSimpleRestRequest;
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

function TSimpleRestRequest.Delete: iSimpleRestRequest;
var
  FStreamResult : TStringStream;
begin
  Result := Self;
  FStreamResult := TStringStream.Create;
  try
//    FIdHTTP.Delete(FBaseURL, FStreamResult);
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

function TSimpleRestRequest.Get: iSimpleRestRequest;
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
  aValue: Boolean): iSimpleRestRequest;
begin
  Result := Self;
  FIdHTTP.HandleRedirects := aValue;
end;

function TSimpleRestRequest.IOHandler(
  aValue: TIdSSLIOHandlerSocketOpenSSL): iSimpleRestRequest;
begin
  Result := Self;
  FIdSSLIOHandlerSocket := aValue;
  FIdHTTP.IOHandler := FIdSSLIOHandlerSocket;
end;

function TSimpleRestRequest.IsBasicAuthentication: Boolean;
begin
  Result := (FIdHTTP.Request.Password <> '') and (FIdHTTP.Request.Username <> '');
end;

class function TSimpleRestRequest.New: iSimpleRestRequest;
begin
    Result := Self.Create;
end;

function TSimpleRestRequest.Password(aValue: string): iSimpleRestRequest;
begin
  Result := Self;
  FIdHTTP.Request.Password := aValue;
  FIdHTTP.Request.BasicAuthentication := IsBasicAuthentication;
end;

function TSimpleRestRequest.Post: iSimpleRestRequest;
begin
  Result := Self;
  FReturn := FIdHTTP.Post(FBaseURL, FStreamSend);
end;

function TSimpleRestRequest.Put: iSimpleRestRequest;
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

function TSimpleRestRequest.UserAgent(aValue: String): iSimpleRestRequest;
begin
  Result := Self;
  FIdHTTP.Request.UserAgent := aValue;
end;

function TSimpleRestRequest.Username(aValue: string): iSimpleRestRequest;
begin
  Result := Self;
  FIdHTTP.Request.Username := aValue;
  FIdHTTP.Request.BasicAuthentication := IsBasicAuthentication;
end;

end.
