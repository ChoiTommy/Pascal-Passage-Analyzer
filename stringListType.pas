unit stringListType;

interface
type stringList = array of string;
procedure add(var l : stringList; s : string);
procedure remove(var l : stringList; s : string; var err : Integer);
procedure clear(var l : stringList);
function isEmpty(l : stringList): Boolean;
function size(l : stringList): Integer;
function contains(l : stringList; s : string): Boolean;

implementation
procedure add(var l : stringList; s : string);
(*
 * Current implementation:
 * add to the last
 * TODO:
 * Do sorting for binary search
 *)
begin
    SetLength(l, Length(l) + 1);
    l[Length(l)-1] := s;
end;

procedure remove(var l : stringList; s : string; var err : Integer);
begin

end;

procedure clear(var l : stringList);
begin
    l := Nil;
end;

function isEmpty(l : stringList): Boolean;
begin
    isEmpty := Length(l) = 0;
end;

function size(l : stringList): Integer;
begin
    size := Length(l);
end;

function contains(l : stringList; s : string): Boolean;
(*
 * Current implementation:
 * Sequential search
 * TODO:
 * Implement binary search
 *)
var i : Integer;
begin
    i := 0;
    contains := False;
    while (i < Length(l)) and not(contains) do
        if l[i] = s then
            contains := True
        else
            i := i + 1;
end;

end.