unit stringListType;

interface
type stringList = array of string;
procedure add(var l : stringList; s : string);
procedure remove(var l : stringList; s : string; var err : Integer);
procedure clear(var l : stringList);
function isEmpty(l : stringList): Boolean;
function size(l : stringList): Integer;
function contains(l : stringList; s : string): Boolean;
procedure sortStringList(var l : stringList);

implementation

procedure swap(var a, b : string);
var temp : string;
begin
    temp := a;
    a := b;
    b := temp;
end;

procedure add(var l : stringList; s : string);
(*
 * Sorting while adding entries
 *)
var i : Integer;
begin
    SetLength(l, Length(l) + 1);
    l[Length(l)-1] := s;
    i := Length(l)-1;
    while (l[i-1] > l[i]) and (i > 0) do //asc
    begin
        swap(l[i-1], l[i]);
        i := i - 1;
    end;
end;

procedure remove(var l : stringList; s : string; var err : Integer);
(*Not yet implemented*)
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

procedure merge(var c : stringList; front, rear : Integer);
var x, y, z, i : integer;
    d : stringList;
begin
    x := front; //first array pointer
    y := (front + rear) div 2 + 1; //second array pointer
    z := front; // temp array pointer
    while (x <= (front + rear) div 2) and (y <= rear) do
    begin
        if (c[x] < c[y]) then
        begin
            d[z] := c[x];
            x := x + 1;
        end
        else
        begin
            d[z] := c[y];
            y := y + 1;
        end;
        z := z + 1;
    end;
    repeat
        if x > (front + rear) div 2 then
        begin
            d[z] := c[y];
            y := y + 1;
        end
        else if y > rear then
        begin
            d[z] := c[x];
            x := x + 1;
        end;
        z := z + 1;
    until z > rear;
    for i := front to rear do //copy all values in the temp array into the actual array
        c[i] := d[i];
end;

procedure mergeSort(var a : stringList; front, rear: integer);
begin
    if front<>rear then //or front < rear
    begin
        MergeSort(a, front, (front + rear) div 2);
        MergeSort(a, (front + rear) div 2 + 1, rear);
        merge(a, front, rear);
    end;
end;

function binarySearch(a : stringList; data : string; first, last : Integer): Boolean;
var mid : Integer;
begin
    mid := (first + last) div 2;
    if (last >= first) then
        if a[mid] = data then
            binarySearch := true
        else if a[mid] > data then
            binarySearch := binarySearch(a, data, first, mid - 1)
        else
            binarySearch := binarySearch(a, data, mid + 1, last)
    else
        binarySearch := false;
end;

function contains(l : stringList; s : string): Boolean;
(*
 * Current implementation:
 * binary search
 *)
begin
    contains := binarySearch(l, s, 0, Length(l)-1);
end;

procedure sortStringList(var l : stringList);
begin
    mergeSort(l, 0, Length(l)-1);
end;

end.