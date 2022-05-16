unit services.cadastros;

{$mode Delphi}

interface

uses
  Classes, SysUtils, SQLDB, provider.connection;

type

  { TServicesCadastros }

  TServicesCadastros = class(TDataModule)
    qryInserePessoa: TSQLQuery;
    qryInsereCliente: TSQLQuery;
    qryBuscaInfo: TSQLQuery;
    qryInsereUsuario: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private

  public
    vProviders : TProviderConnection;

  end;

var
  ServicesCadastros: TServicesCadastros;

implementation

{$R *.lfm}

{ TServicesCadastros }

procedure TServicesCadastros.DataModuleCreate(Sender: TObject);
begin
    vProviders := TProviderConnection.Create(Nil);
    vProviders.dbConnection.Connected := True;
    qryInserePessoa.DataBase                := vProviders.dbConnection;
    qryInserePessoa.Transaction             := vProviders.dbTransaction;

    qryInsereCliente.DataBase                := vProviders.dbConnection;
    qryInsereCliente.Transaction             := vProviders.dbTransaction;

    qryInsereUsuario.DataBase                := vProviders.dbConnection;
    qryInsereUsuario.Transaction             := vProviders.dbTransaction;

    qryBuscaInfo.DataBase                := vProviders.dbConnection;
    qryBuscaInfo.Transaction             := vProviders.dbTransaction;
end;

procedure TServicesCadastros.DataModuleDestroy(Sender: TObject);
begin
    if Assigned(vProviders) then  FreeAndNil(vProviders);
end;


end.

