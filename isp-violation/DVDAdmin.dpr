program DVDAdmin;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  DVD,
  StockManager in 'StockManager.pas';

var
  lManager : TStockManager;
  lDummy : string;

begin
  try
    lManager := TStockManager.Create();
    try
      lManager.AddDVD(TDVD.Create('Movie 1', 6, 10, 5, 55));
      Writeln(lManager.GetTotalStockInfo());
      Readln(lDummy);
    finally
      lManager.Free();
    end;
  except
    on E : Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.
