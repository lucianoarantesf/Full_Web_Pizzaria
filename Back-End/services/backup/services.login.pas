unit services.login;

{$mode Delphi}

interface

uses
  Classes, SysUtils,provider.connection, SQLDB, Uni;

type

  { TServicesLogin }

  TServicesLogin = class(TDataModule)
    qryLogin: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private

  public
     vProviders : TProviderConnection;
  end;

var
  ServicesLogin: TServicesLogin;

implementation

{$R *.lfm}

{ TServicesLogin }

procedure TServicesLogin.DataModuleCreate(Sender: TObject);
begin
    vProviders := TProviderConnection.Create(Nil);
    vProviders.dbConnection.Connected := True;
    qryLogin.DataBase                := vProviders.dbConnection;
    qryLogin.Transaction             := vProviders.dbTransaction;
end;

procedure TServicesLogin.DataModuleDestroy(Sender: TObject);
begin
  if Assigned(vProviders) then  FreeAndNil(vProviders);
end;

end.

