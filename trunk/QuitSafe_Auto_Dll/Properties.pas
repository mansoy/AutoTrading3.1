unit Properties;

interface

uses
  Classes, SysUtils, Dialogs;
type
  TProperties = class(TObject)
    private
      FStringList: TStringList;
      FFileName: string;
    public
      Constructor Create(fileName: string);
      Destructor Destroy; override;

      procedure Load(fileName: string);
      function getValues(key: string): string;
      procedure setValues(key, value: string);
      procedure append(key, value: string);
      procedure save;
  end;
implementation

{ TProperties }

procedure TProperties.append(key, value: string);
begin
  FStringList.Add(key + '='+ value);
end;

constructor TProperties.Create(fileName: string);
begin
  FStringList := TStringList.Create;
  FFileName := fileName;
  Load(fileName);
end;

destructor TProperties.Destroy;
begin
  FStringList.Free;
  inherited;
end;

function TProperties.getValues(key: string): string;
var
  I: Integer;
begin
  for I := 0 to FStringList.Count - 1 do
  begin
    if (FStringList.Strings[I] <> '') and (Copy(FStringList.Strings[I], 0, 1) <> '#') then
    begin
      if Pos(key, FStringList.Strings[I]) > 0 then
        Result:= Copy(FStringList.Strings[I], Pos('=', FStringList.Strings[I]) + 1, length(FStringList.Strings[I]));
    end;
  end;
end;

procedure TProperties.Load(fileName: string);
begin
  FStringList.Clear;
  if FileExists(fileName) then
    FStringList.LoadFromFile(fileName);
end;

procedure TProperties.save;
begin
  FStringList.SaveToFile(FFileName);
end;

procedure TProperties.setValues(key, value: string);
var
  I: Integer;
begin
  for I := 0 to FStringList.Count - 1 do
  begin
    if (FStringList.Strings[I] <> '') and (Copy(FStringList.Strings[I], 0, 1) <> '#') then
    begin
      if Pos(key, FStringList.Strings[I]) > 0 then
        FStringList.Strings[I] := Copy(FStringList.Strings[I], 0, Pos('=', FStringList.Strings[I])) + value;
    end;
  end;
end;

end.

