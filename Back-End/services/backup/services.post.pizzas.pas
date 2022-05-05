unit services.post.pizzas;

{$mode Delphi}

interface

uses
  Classes, SysUtils,  provider.connection, Uni  ;

type

  { TServicesPostPizzas }

  TServicesPostPizzas = class(TDataModule)
    qryInsere: TUniQuery;
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
end;

procedure TServicesPostPizzas.DataModuleDestroy(Sender: TObject);
begin
      if Assigned(vProviders) then  FreeAndNil(vProviders);
end;

end.

