unit provider.connection;
{$MODE DELPHI}{$H+}

interface

uses
  Classes, SysUtils, ActiveX, SQLite3Conn, SQLDB;

type

  { TProviderConnection }

  TProviderConnection = class(TDataModule)
    dbConnection: TSQLite3Connection;
    dbTransaction: TSQLTransaction;
    procedure dbConnectionAfterConnect(Sender: TObject);
    procedure dbConnectionBeforeConnect(Sender: TObject);
    procedure dbConnectionBeforeDisconnect(Sender: TObject);
  private

  public

  end;

var
  ProviderConnection: TProviderConnection;

implementation

{$R *.lfm}

{ TProviderConnection }




procedure TProviderConnection.dbConnectionBeforeConnect(Sender: TObject);
begin
  CoInitialize(nil);
end;

procedure TProviderConnection.dbConnectionAfterConnect(Sender: TObject);
begin
end;

procedure TProviderConnection.dbConnectionBeforeDisconnect(Sender: TObject);
begin
    CoUninitialize;
end;



end.

