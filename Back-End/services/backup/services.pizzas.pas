unit services.pizzas;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Uni,
  provider.connection;

type

  { TServicesPizzas }

  TServicesPizzas = class(TDataModule)
    qryPizzas: TUniQuery;
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
    vProviders := TProvidersConnection.Create(Nil);
    vProviders.dbsConnection.Connected := True;
    qryPizzas.Connection := vProviders.dbsConnection;
end;

procedure TServicesPizzas.DataModuleDestroy(Sender: TObject);
begin
    if Assigned(vProviders) then  FreeAndNil(vProviders);
end;

end.

