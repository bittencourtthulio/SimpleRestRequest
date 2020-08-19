unit SimpleRestRequest.Interfaces;

interface

uses
  System.JSON;

type
  iSimpleRestResquest = interface
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

end.
