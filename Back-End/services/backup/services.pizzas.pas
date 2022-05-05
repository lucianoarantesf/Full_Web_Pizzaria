unit services.pizzas;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Uni,
  provider.connection, SQLDB;

type

  { TServicesPizzas }

  TServicesPizzas = class(TDataModule)
    qryPizzas: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  private

  public
    vProviders : TProviderConnection;
  end;

var
  ServicesPizzas: TServicesPizzas;

implementation

{$R *.lfm}

{ TServicesPizzas }


procedure TServicesPizzas.DataModuleCreate(Sender: TObject);
begin
    vProviders := TProviderConnection.Create(Nil);
    vProviders.dbConnection.Connected := True;
    qryPizzas.DataBase                := vProviders.dbConnection;
    qryPizzas.Transaction             := vProviders.dbTransaction;
end;

procedure TServicesPizzas.DataModuleDestroy(Sender: TObject);
begin
    if Assigned(vProviders) then  FreeAndNil(vProviders);
end;

end.

