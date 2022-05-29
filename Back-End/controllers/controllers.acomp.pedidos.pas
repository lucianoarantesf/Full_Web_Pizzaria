unit controllers.acomp.pedidos;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Horse, Jsons, DataSet.Serialize;

type { TAcomPedidos }
  TAcomPedidos = class
    class procedure registry;
  end;

implementation

uses services.post.pizzas;

procedure onGetAcompPedidos(Req : THorseRequest; Res : THorseResponse; Next: TNextProc);
var
   LServicesPizzas     : TServicesPostPizzas;
   LJsonArray          :TJsonArray;
   vId,lSumary         :String;
   lPedido             :Integer;
begin
  LServicesPizzas := TServicesPostPizzas.Create(nil);
  LJsonArray      := TJsonArray.Create(nil);
  try
    try

      LJsonArray.Clear;

      if not (Req.Query.ContainsKey('id')) then
        raise Exception.Create('Id não informado.');
      vId := '';
      vId := Req.Query.Items['id'];
      lPedido:=0;

       with LServicesPizzas do
       begin
          qryBuscaInfoPedido.Close;
          qryBuscaInfoPedido.SQL.Clear;
          qryBuscaInfoPedido.SQL.Text := 'SELECT                            '+
                                         '   PD.NRO_PEDIDO AS NRO_PEDIDO,   '+
                                         '   P.PIZZA AS PIZZA,              '+
                                         '   PD.QUANTIDADE AS QUANTIDADE,   '+
                                         '   PD.END_ENTREGA AS END_ENTREGA, '+
                                         '   PD.DT_PEDIDO AS DT_PEDIDO,     '+
                                         '   PD.HR_PEDIDO AS HR_PEDIDO,     '+
                                         '   PD.STATUS AS STATUS            '+
                                         'FROM                              '+
                                         '    PEDIDO PD                     '+
                                         'JOIN                              '+
                                         '  PIZZA P ON                      '+
                                         '  P.ID = PD.ID_PIZZA              '+
                                         'JOIN                              '+
                                         '   CLIENTE C ON                   '+
                                         '   C.ID_CLIENTE = PD.ID_CLIENTE   '+
                                         '   AND C.ID_PESSOA = :ID          ';
          qryBuscaInfoPedido.ParamByName('ID').AsInteger := vId.ToInteger;
          qryBuscaInfoPedido.Open;

           qryBuscaInfoPedido.First;
           while not (qryBuscaInfoPedido.EOF) do
           begin
              lSumary := '<summary>Pedido Nro: '+qryBuscaInfoPedido.FieldByName('NRO_PEDIDO').AsString+' - '+qryBuscaInfoPedido.FieldByName('STATUS').AsString+ '</summary>'+
              ' - Pizza: '+qryBuscaInfoPedido.FieldByName('PIZZA').AsString + '<br>' +
              ' - O Pedido '+qryBuscaInfoPedido.FieldByName('NRO_PEDIDO').AsString+
              ' foi realizado no dia '+qryBuscaInfoPedido.FieldByName('DT_PEDIDO').AsString+
              ' as '+qryBuscaInfoPedido.FieldByName('HR_PEDIDO').AsString+
              ' entrega no Endereco: '+qryBuscaInfoPedido.FieldByName('END_ENTREGA').AsString;
            LJsonArray.Put('<details>' + lSumary + '</details>' );
           qryBuscaInfoPedido.Next;
           end;


         Res.ContentType('application/json')
            .Send(LJsonArray.Stringify)
            .Status(200);
       end;
    except
        on E:exception do
        begin
           Res.ContentType('application/json; charset=utf-8').Send(Format('{"retorno":"%s"}',[e.message])).status(500);
        end;
    end;

  finally
    FreeAndNil(LServicesPizzas);
    FreeAndNil(LJsonArray);
  end;
end;

{ TAcomPedidos }
class procedure TAcomPedidos.registry;
begin
   THorse.Get('/acompanhamento/pedidos', onGetAcompPedidos);
end;

end.

