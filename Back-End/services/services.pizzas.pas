unit services.pizzas;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  Uni, VirtualTable, VirtualDataSet,
  provider.connection, SQLDB, csvdataset, DB, BufDataset;

type

  { TServicesPizzas }

  TServicesPizzas = class(TDataModule)
    CSVDataset: TCSVDataset;
    qryPizzasDETALHE: TMemoField;
    qryPizzasID: TMemoField;
    qryPizzasPIZZA: TMemoField;
    qryPizzasTAGID: TLongintField;
    qryPizzasTITLE: TMemoField;
    qryPizzasVALOR: TFloatField;
    VirtualTable: TBufDataset;
    qryPizzas: TSQLQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);

  private

  public
    vProviders : TProviderConnection;
    function SaveToCSV(aDataSet : TSQLQuery) : String;
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

function TServicesPizzas.SaveToCSV(aDataSet : TSQLQuery): String;
const
  Delimiter: Char = ';'; // In order to be automatically recognized in Microsoft Excel use ";", not ","
  Enclosure: Char = '"';
var
  List: String;
  S: String;
  function EscapeString(s: string): string;
  begin
    Result := StringReplace(s,Enclosure,Enclosure+Enclosure,[rfReplaceAll]);
    if (Pos(Delimiter,s) > 0) OR (Pos(Enclosure,s) > 0) then  // Comment this line for enclosure in every fields
        Result := Enclosure+Result+Enclosure;
  end;
  procedure AddHeader;
  var
    I: Integer;
  begin
    S := '';
    for I := 0 to aDataSet.FieldCount - 1 do begin
      if S > '' then
        S := S + Delimiter;
      S := S + EscapeString(aDataSet.Fields[I].FieldName);
    end;
    List := List + S +''+ #13;
  end;
  procedure AddRecord;
  var
    I: Integer;
  begin
    S := '';
    for I := 0 to aDataSet.FieldCount - 1 do begin
      if S > '' then
        S := S + Delimiter;
      S := S + EscapeString(aDataSet.Fields[I].AsString);
    end;
    List := List + S +''+ #13;
  end;
begin
  try
    aDataSet.DisableControls;
    aDataSet.First;
    AddHeader;  // Comment if header not required
    while not aDataSet.Eof do begin
      AddRecord;
      aDataSet.Next;
    end;
  finally
    aDataSet.First;
    aDataSet.EnableControls;
  end;
  Result := List;
end;

end.

