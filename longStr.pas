unit longStr;

interface
type longString = array of Char;
procedure readLongString(var s : longString);
procedure readLongString(var t : Text; var s : longString);

implementation
procedure readLongString(var s : longString);
var n : Integer;
    c : Char;
begin
    n := 0;
    Read(c);
    while c <> ' ' do
    begin
        n := n + 1;
        SetLength(s, n);
        s[n-1] := c;
        Read(c);
    end;
end;

procedure readLongString(var t : Text; var s : longString);
var n : Integer;
    c : Char;
begin
    n := 0;
    while not EOF(t) do
    begin
        n := n + 1;
        SetLength(s, n);
        Read(t, c);
        s[n-1] := c;
    end;
end;

end.