unit controllers.post.pizzas;

{$mode Delphi}

interface

uses
  Classes, SysUtils, jsonparser, fpjson, Horse, DataSet.Serialize;

type {TPostPizzas}
  TPostPizzas = class
    class procedure registry;
  end;

implementation
uses services.post.pizzas;

procedure setPizzas(Req : THorseRequest; Res : THorseResponse; Next: TNextProc);
var
   LServicesPostPizzas     : TServicesPostPizzas;
   LJsonParse              : TJSONParser;
   LJsonArray              : TJsonArray;
   vString                  :String;
begin
  LServicesPostPizzas := TServicesPostPizzas.Create(nil);
  vString       := Req.Body();
  LJsonParse    := TJSONParser.Create(Req.Body);
  LJsonArray    := LJsonParse.Parse as TJSONArray;
  try
    try

      LServicesPostPizzas.vProviders.dbTransaction.StartTransaction;

       with LServicesPostPizzas do
       begin
            MemTable.Close;
            MemTable.LoadFromJSON(LJsonArray, True);

          qryBuscaInfoPedido.Close;
          qryBuscaInfoPedido.SQL.Clear;
          qryBuscaInfoPedido.SQL.Text := 'SELECT ifnull(MAX(NRO_PEDIDO),0) AS NRO_PEDIDO FROM PEDIDO';
          qryBuscaInfoPedido.Open;

           MemTable.First;
           while not (MemTable.EOF) do
           begin
                qryBuscaInfo.Close;
                qryBuscaInfo.SQL.Clear;
                qryBuscaInfo.sql.Text := 'SELECT C.ID_CLIENTE, P.ENDERECO FROM CLIENTE C, PESSOA P WHERE C.ID_PESSOA = P.ID_PESSOA AND P.ID_PESSOA = :ID_PESSOA';
                qryBuscaInfo.ParamByName('ID_PESSOA').AsInteger := MemTable.FieldByName('ID_PESSOA').AsInteger;
                qryBuscaInfo.Open;

               qryInsere.Close;
               qryInsere.SQL.Clear;
               qryInsere.SQL.Text := 'INSERT INTO PEDIDO( ID_CLIENTE, ID_PIZZA, NRO_PEDIDO, QUANTIDADE, STATUS, END_ENTREGA, DT_PEDIDO, HR_PEDIDO) ';
               qryInsere.SQL.Add('                VALUES(:ID_CLIENTE,:ID_PIZZA,:NRO_PEDIDO,:QUANTIDADE,:STATUS,:END_ENTREGA,:DT_PEDIDO,:HR_PEDIDO) ');
               qryInsere.ParamByName('ID_CLIENTE').AsInteger  := qryBuscaInfo.FieldByName('ID_CLIENTE').AsInteger;
               qryInsere.ParamByName('ID_PIZZA').AsString     := MemTable.FieldByName('id').AsString;
               qryInsere.ParamByName('NRO_PEDIDO').AsInteger  := qryBuscaInfoPedido.FieldByName('NRO_PEDIDO').AsInteger + 1;
               qryInsere.ParamByName('QUANTIDADE').AsInteger  := MemTable.FieldByName('quantidade').AsInteger;
               qryInsere.ParamByName('STATUS').AsString       := 'EM ANDAMENTO';
               qryInsere.ParamByName('END_ENTREGA').AsString  := qryBuscaInfo.FieldByName('ENDERECO').AsString;
               qryInsere.ParamByName('DT_PEDIDO').AsString    := FormatDateTime('DD/MM/YYYY', Date);
               qryInsere.ParamByName('HR_PEDIDO').AsString    := FormatDateTime('hh:mm:ss', Now);
               qryInsere.ExecSQL;

             MemTable.Next;
           end;

         LServicesPostPizzas.vProviders.dbTransaction.Commit;
         Res.ContentType('application/json').Send(Format('{"retorno":"%s"}',['OK'])).status(200);
       end;
    except
        on E:exception do
        begin
           LServicesPostPizzas.vProviders.dbTransaction.Rollback;
           Res.ContentType('application/json').Send(Format('{"retorno":"%s"}',[e.message])).status(500);
        end;
    end;

  finally
    FreeAndNil(LServicesPostPizzas);
    FreeAndNil(LJsonParse);
  end;
end;

{ TPostPizzas }

class procedure TPostPizzas.registry;
begin
  THorse.Post('pizzas/post', setPizzas);
end;

end.

