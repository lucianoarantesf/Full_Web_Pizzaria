unit provider.connection;
{$MODE DELPHI}{$H+}

interface

uses
  Classes, SysUtils, Uni, SQLServerUniProvider,ActiveX;

type

  { TProviderConnection }

  TProviderConnection = class(TDataModule)
    SQLServerUniProvider: TSQLServerUniProvider;
    dbsConnection: TUniConnection;
    procedure dbsConnectionBeforeConnect(Sender: TObject);
    procedure dbsConnectionBeforeDisconnect(Sender: TObject);
  private

  public

  end;

var
  ProviderConnection: TProviderConnection;

implementation

{$R *.lfm}

{ TProviderConnection }


procedure TProviderConnection.dbsConnectionBeforeConnect(Sender: TObject);
begin
 CoInitialize(nil);
end;

procedure TProviderConnection.dbsConnectionBeforeDisconnect(Sender: TObject);
begin
  CoUninitialize;
end;

end.

