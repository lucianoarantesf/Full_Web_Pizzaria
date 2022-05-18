unit services.post.pizzas;

{$mode Delphi}

interface

uses
  Classes, SysUtils, provider.connection, SQLDB, BufDataset, DB, Uni,
  VirtualTable;

type

  { TServicesPostPizzas }

  TServicesPostPizzas = class(TDataModule)
    MemTable: TVirtualTable;
    MemTabledetalhe: TStringField;
    MemTableid: TStringField;
    MemTableID_PESSOA: TLongintField;
    MemTablepizza: TStringField;
    MemTablequantidade: TLongintField;
    MemTablevalor: TFloatField;
    qryBuscaInfoPedido: TSQLQuery;
    qryInsere: TSQLQuery;
    qryBuscaInfo: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private

  public
       vProviders : TProviderConnection;
  end;

var
  ServicesPostPizzas: TServicesPostPizzas;

implementation

{$R *.lfm}

{ TServicesPostPizzas }

procedure TServicesPostPizzas.DataModuleCreate(Sender: TObject);
begin
    vProviders := TProviderConnection.Create(Nil);
    vProviders.dbConnection.Connected := True;

    qryInsere.DataBase                := vProviders.dbConnection;
    qryInsere.Transaction             := vProviders.dbTransaction;

    qryBuscaInfo.DataBase                := vProviders.dbConnection;
    qryBuscaInfo.Transaction             := vProviders.dbTransaction;

    qryBuscaInfoPedido.DataBase                := vProviders.dbConnection;
    qryBuscaInfoPedido.Transaction             := vProviders.dbTransaction;
end;

procedure TServicesPostPizzas.DataModuleDestroy(Sender: TObject);
begin
      if Assigned(vProviders) then  FreeAndNil(vProviders);
end;

end.

