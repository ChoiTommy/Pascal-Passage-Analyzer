program colors;
uses
    crt;
var i : Integer;
begin
    for i := 0 to 29 do
    begin
        TextBackground(i);
        Writeln(i, ' 0123456789abcdefghijklmnopqrstuvwxyz!@#$%^&*()_+');
    end;

    ReadLn;
end.