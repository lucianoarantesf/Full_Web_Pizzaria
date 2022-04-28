unit controllers.post.pizzas;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Jsons, Horse, DataSet.Serialize;

type {TPostPizzas}
  TPostPizzas = class
    class procedure registry;
  end;

implementation
uses services.post.pizzas;

procedure setPizzas(Req : THorseRequest; Res : THorseResponse; Next: TNextProc);
var
   LServicesPostPizzas     : TServicesPostPizzas;
   L
begin
  LServicesPostPizzas := TServicesPostPizzas.Create(nil);
  try
    try
       with LServicesPostPizzas do
       begin



         Res.ContentType('application/json').Send(Format('{"STATUS":"%s"}',['OK'])).status(200);
       end;
    except
        on E:exception do
        begin
           Res.ContentType('application/json').Send(Format('{"ERROR":"%s"}',[e.message])).status(500);
        end;
    end;

  finally
    FreeAndNil(LServicesPostPizzas);
  end;
end;

{ TPostPizzas }

class procedure TPostPizzas.registry;
begin
  THorse.Post('pizzas/post', setPizzas);
end;

end.

