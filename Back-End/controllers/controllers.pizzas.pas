unit controllers.pizzas;

{$mode Delphi}

interface

uses
  Classes, SysUtils,fpjson, jsonparser, Horse, DataSet.Serialize;

type {TPizzas}
  TPizzas = class
    class procedure registry;
  end;

implementation

uses services.pizzas;

procedure getPizzas(Req : THorseRequest; Res : THorseResponse; Next: TNextProc);
var
   LServicesPizzas     : TServicesPizzas;
   vId                 : String;
begin
  LServicesPizzas := TServicesPizzas.Create(nil);
  try
    try
       with LServicesPizzas do
       begin
         qryPizzas.Close;

          vId := '';
          if Req.Query.ContainsKey('id') then
          begin
           vId := Req.Query.Items['id'];
           qryPizzas.SQL.Strings[5] := 'AND ID = :ID';
           qryPizzas.ParamByName('ID').AsString := vId;
          end;

          qryPizzas.Open;

         Res.ContentType('application/json').Send(qryPizzas.ToJSONArrayString).status(200);
       end;
    except
        on E:exception do
        begin
           Res.ContentType('application/json').Send(Format('{"ERROR":"%s"}',[e.message])).status(500);
        end;
    end;

  finally
    FreeAndNil(LServicesPizzas);
  end;
end;

{ TPizzas }

class procedure TPizzas.registry;
begin
  THorse.Get('pizzas', getPizzas);
end;

end.

