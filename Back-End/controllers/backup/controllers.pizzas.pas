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
   LRespJSON           : TJSONObject;
   vId                 : String;
begin
  LRespJSON           := TJSONObject.Create();
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
           qryPizzas.SQL.Strings[5] := 'ID = :ID';
           qryPizzas.ParamByName('ID').AsString := vId;
          end;

         qryPizzas.Open;

         if qryPizzas.IsEmpty then
         begin
            LRespJSON.Clear;
            LRespJSON.Add('success',False);
            LRespJSON.Add('status',200);
            LRespJSON.Add('message', UTF8Decode( 'Pizza não encontrada.' ) );
         end
         else
         begin
            LRespJSON.Clear;
            LRespJSON.Add('success',True);
            LRespJSON.Add('status',200);
            LRespJSON.Add('message','Total de Registros: ' + qryPizzas.RecordCount.ToString);
            LRespJSON.Add('records', qryPizzas.RecordCount);
            LRespJSON.Add('data', qryPizzas.ToJSONArray());
            qryPizzas.First;
            LDados :=  '[ ' ;
            while not qryPizzas.EOF do
            begin
             LDados := LDados + ' [ ' + '"' + qryPizzas.FieldByName('ID').AsString         + '",'
                                      + '"' + qryPizzas.FieldByName('TITLE').AsString      + '",'
                                      + '"' + qryPizzas.FieldByName('PIZZA').AsString      + '",'
                                      + '"' + qryPizzas.FieldByName('VALOR').AsString      + '",'
                                      + '"' + qryPizzas.FieldByName('DETALHE').AsString    + '"'
                              + ' ],';
             qryPizzas.next;
            end;
            LDados := Copy(LDados, 1 ,Length(LDados)-1);
            LDados := LDados + ' ]' ;

            LRespJSON.Add('tabledata', LDados);
         end;

         qryPizzas.Close;

         Res.ContentType('application/json').Send(  LRespJSON.AsJSON ).status(200);
       end;
    except
        on E:exception do
        begin
           Res.ContentType('application/json').Send(Format('{"ERROR":"%s"}',[e.message])).status(500);
        end;
    end;

  finally
    FreeAndNil(LServicesPizzas);
    FreeAndNil(LRespJSON);
  end;
end;

{ TPizzas }

class procedure TPizzas.registry;
begin
  THorse.Get('pizzas', getPizzas);
end;

end.

