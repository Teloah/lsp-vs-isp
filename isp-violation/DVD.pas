unit DVD;

interface

type
  TDVD = class
  private
    FAgeLimit : Integer;
    FName : string;
    FPrice : Integer;
    FRunningTime : TTime;
    FStock : Integer;
  public
    constructor Create(const aName : string; const aAgeLimit, aPrice, aStock : Integer; aRunningTime : TTime);
    function AgeLimit() : Integer;
    function Name() : string;
    function Price() : Integer;
    function RunningTime() : TTime;
    function Stock() : Integer;
  end;

implementation

{ TDVD }

constructor TDVD.Create(const aName : string; const aAgeLimit, aPrice, aStock : Integer; aRunningTime : TTime);
begin
  inherited Create();
  FAgeLimit := aAgeLimit;
  FName := aName;
  FPrice := aPrice;
  FRunningTime := aRunningTime;
  FStock := aStock;
end;

function TDVD.Name() : string;
begin
  Result := FName;
end;

function TDVD.AgeLimit() : Integer;
begin
  Result := FAgeLimit;
end;

function TDVD.Price() : Integer;
begin
  Result := FPrice;
end;

function TDVD.RunningTime() : TTime;
begin
  Result := FRunningTime;
end;

function TDVD.Stock() : Integer;
begin
  Result := FStock;
end;

end.
