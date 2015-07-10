unit StockManager;

interface

uses
  System.SysUtils, Generics.Collections, DVD;

type
  TStockManager = class
  private
    FDVDs : TObjectList<TDVD>;
  public
    constructor Create();
    destructor Destroy(); override;
    procedure AddDVD(aDVD : TDVD);
    function GetTotalPrice() : Integer;
    function GetTotalStockInfo() : string;
  end;

implementation

{ TStockManager }

constructor TStockManager.Create();
begin
  inherited;
  FDVDs := TObjectList<TDVD>.Create();
end;

destructor TStockManager.Destroy();
begin
  FDVDs.Free();
  inherited;
end;

procedure TStockManager.AddDVD(aDVD : TDVD);
begin
  FDVDs.Add(aDVD);
end;

function TStockManager.GetTotalPrice() : Integer;
var
  lDVD : TDVD;
begin
  Result := 0;
  for lDVD in FDVDs do begin
    Inc(Result, lDVD.Price());
  end;
end;

function TStockManager.GetTotalStockInfo() : string;
var
  lDVD : TDVD;
begin
  Result := '';
  for lDVD in FDVDs do begin
    Result := Format('%s: %d'#13#10, [lDVD.Name, lDVD.Stock]);
  end;
end;

end.
