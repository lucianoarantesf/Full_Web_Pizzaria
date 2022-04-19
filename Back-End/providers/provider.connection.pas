unit provider.connection;

{$mode Delphi}

interface

uses
  Classes, SysUtils, Uni, SQLServerUniProvider, MySQLUniProvider,ActiveX;

type

  { TProviderConnection }

  TProviderConnection = class(TDataModule)
    SQLServerUniProvider: TSQLServerUniProvider;
    dbsConnection: TUniConnection;
  private

  public

  end;

var
  ProviderConnection: TProviderConnection;

implementation

{$R *.lfm}

{ TProviderConnection }


end.

