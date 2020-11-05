unit SimpleRestRequest.Interfaces;

interface

{$I SimpleRestRequest.inc}

uses
  {$ifdef HASJSONDATAOBJCTS}JsonDataObjects,{$endif}
  {$IF CompilerVersion > 22}
   System.JSON,
  {$IFEND}
  IdSSLOpenSSL;

type
  iSimpleRestRequest = interface
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
    {$IF CompilerVersion > 22}
    function Body (aValue : TJsonObject) : iSimpleRestRequest; overload;
    {$IFEND}
    {$ifdef HASJSONDATAOBJCTS}
    function Body (aValue : TJDOJsonObject) : iSimpleRestRequest; overload;
    {$endif}
    function Post : iSimpleRestRequest;
    function Get : iSimpleRestRequest;
    function Delete : iSimpleRestRequest;
    function Put : iSimpleRestRequest;
    function Return : String;
  end;

implementation

end.
