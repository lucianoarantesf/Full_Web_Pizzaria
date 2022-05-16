unit controllers.cadastros;


{$mode Delphi}

interface

uses
  Classes, SysUtils,jsons, Horse, DataSet.Serialize;

type {TCadastros}
  TCadastros = class
    class procedure registry;
  end;
implementation

uses services.cadastros;

procedure setUsuarios(Req : THorseRequest; Res : THorseResponse; Next: TNextProc);
var
   LServicesCadastros     : TServicesCadastros;
   LJsonObj             : TJsonObject;
   ID_PESSOA              : Integer;
begin
  LServicesCadastros := TServicesCadastros.Create(nil);
  LJsonObj          := TJsonObject.Create(nil);
  try
    try
       with LServicesCadastros do
       begin
           LJsonObj.Parse(Req.Body);

           vProviders.dbTransaction.StartTransaction;

           qryBuscaInfo.Close;
           qryBuscaInfo.SQL.Clear;
           qryBuscaInfo.SQL.Text := 'SELECT MAX(ID_PESSOA) AS ID_PESSOA FROM PESSOA';
           qryBuscaInfo.Open;

           ID_PESSOA := qryBuscaInfo.FieldByName('ID_PESSOA').AsInteger;

           qryInserePessoa.Close;
           qryInserePessoa.SQL.Clear;
           qryInserePessoa.SQL.Text := 'INSERT INTO PESSOA( ID_PESSOA, NOME, ENDERECO, CPF)';
           qryInserePessoa.SQL.Add('                VALUES(:ID_PESSOA,:NOME,:ENDERECO,:CPF)');
           qryInserePessoa.ParamByName('ID_PESSOA').AsInteger := ID_PESSOA + 1;
           qryInserePessoa.ParamByName('NOME').AsString       := LJsonObj.Values['NOME'].AsString;
           qryInserePessoa.ParamByName('ENDERECO').AsString   := LJsonObj.Values['ENDERECO'].AsString;
           qryInserePessoa.ParamByName('CPF').AsString        := LJsonObj.Values['CPF'].AsString;
           qryInserePessoa.ExecSQL;

           qryInsereCliente.Close;
           qryInsereCliente.SQL.Clear;
           qryInsereCliente.SQL.Text := 'INSERT INTO CLIENTE( ID_PESSOA, ID_CLIENTE, FORMA_PAGAMENTO)';
           qryInsereCliente.SQL.Add('                 VALUES(:ID_PESSOA,:ID_CLIENTE,   ''DINHEIRO'' )');
           qryInsereCliente.ParamByName('ID_PESSOA').AsInteger  := ID_PESSOA + 1;
           qryInsereCliente.ParamByName('ID_CLIENTE').AsInteger := ID_PESSOA + 10;
           qryInsereCliente.ExecSQL;

           qryInsereUsuario.Close;
           qryInsereUsuario.SQL.Clear;
           qryInsereUsuario.SQL.Text := 'INSERT INTO USUARIO( ID_PESSOA, USUARIO, SENHA)';
           qryInsereUsuario.SQL.Add('                 VALUES(:ID_PESSOA,:USUARIO,:SENHA)');
           qryInsereUsuario.ParamByName('ID_PESSOA').AsInteger := ID_PESSOA + 1;
           qryInsereUsuario.ParamByName('USUARIO').AsString    := LJsonObj.Values['USUARIO'].AsString;
           qryInsereUsuario.ParamByName('SENHA').AsString      := LJsonObj.Values['SENHA'].AsString;
           qryInsereUsuario.ExecSQL;

           vProviders.dbTransaction.Commit;

         Res.ContentType('application/json').Send(Format('{"retorno":"%s"}',['OK'])).status(200);
       end;
    except
        on E:exception do
        begin
           Res.ContentType('application/json').Send(Format('{"retorno":"%s"}',[e.message])).status(500);
        end;
    end;

  finally
    FreeAndNil(LServicesCadastros);
    FreeAndNil(LJsonObj);
  end;
end;

{ TCadastros }

class procedure TCadastros.registry;
begin
  THorse.Group
        .Prefix('cadastros')
        .Post('usuarios',setUsuarios );

end;

end.

