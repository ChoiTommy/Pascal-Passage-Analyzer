program pos_test;
uses longStringType;
const s = 'Hi there this is here.';
var a : longString;
    x : positionArray;
    i : Integer;
begin
    SetLength(a, Length(s));
    for i := 0 to Length(s)-1 do
        a[i] := s[i+1];

    x := posOfString('here', a);
    for i := 0 to Length(x)-1 do
        WriteLn(x[i]);
    ReadLn;
end.