unit controllers.logins;

{$mode Delphi}

interface

uses
  Classes, SysUtils,fpjson, jsonparser, Horse, DataSet.Serialize;

type {TLogin}
  TLogin = class
    class procedure registry;
  end;
implementation

uses services.login;

procedure doLogin(Req : THorseRequest; Res : THorseResponse; Next: TNextProc);
var
   LServicesLogin     : TServicesLogin;
   LUser              : String;
   LPass              : String;
begin
  LServicesLogin := TServicesLogin.Create(nil);
  LUser :=  '';
  LPass :=  '';
  try
    try
       with LServicesLogin do
       begin
         LUser :=  Req.RawWebRequest.GetCustomHeader('X-USER');
         LPass :=  Req.RawWebRequest.GetCustomHeader('X-PASS');

         qryLogin.Close;
         qryLogin.ParamByName('USER').AsString := LUser ;
         qryLogin.ParamByName('PASS').AsString := LPass ;
         qryLogin.Open;

         if not (qryLogin.IsEmpty) then
            Res.ContentType('application/json').Send(Format('{"retorno":"%s"}',['OK'])).status(200)
         else
            Res.ContentType('application/json').Send(Format('{"retorno":"%s"}',['Usuáro ou Senha Invalidos'])).status(401);

       end;
    except
        on E:exception do
        begin
           Res.ContentType('application/json').Send(Format('{"retorno":"%s"}',[e.message])).status(500);
        end;
    end;

  finally
    FreeAndNil(LServicesLogin);
  end;
end;

{ TLogin }

class procedure TLogin.registry;
begin
  THorse.Get('login', doLogin);
end;

end.

