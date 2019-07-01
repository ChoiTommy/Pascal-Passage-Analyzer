unit longStr;

interface
type longString = array of Char;
procedure readLongString(var s : longString);
procedure readLongString(var t : Text; var s : longString);
procedure writeLongString(s : longString);
function countInLongString(c : Char; s : longString) : Integer;
function countInLongString(t : string; s : longString) : Integer;
function posOfChar(c : char; s : longString) : Integer;
function copy(s : longString; start, count : Integer): string;
function copy(s : longString; start : Integer): string;
function stringToLongString(s : string): longString;
function longStringToString(s : longString): string;

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

procedure writeLongString(s : longString);
var i : Integer;
begin
    for i := 0 to Length(s)-1 do
        if (s[i] >= #32) and (s[i] <= #126) then
            Write(s[i])
        else if (s[i] = #13) and (s[i+1] = #10) then
        begin
            WriteLn;
            WriteLn;
        end;
end;

function countInLongString(c : Char; s : longString) : Integer;
var i : Integer;
begin
    countInLongString := 0;
    for i := 0 to Length(S)-1 do
        if s[i] = c then
            countInLongString := countInLongString + 1;
end;

function countInLongString(t : string; s : longString) : Integer;
var i, j : Integer;
    temp : string;
begin
    countInLongString := 0;
    for i := 0 to Length(S)-1 do
    begin
        temp := '';
        for j := 1 to Length(t) do
            temp := temp + s[i+j-1];
        if t = temp then
            countInLongString := countInLongString + 1;
    end;
end;

function posOfChar(c : char; s : longString) : Integer;
var i : Integer;
begin
    i := 0;
    posOfChar := -1;
    while (i <= Length(s)-1) and (s[i] <> c)  do
        i := i + 1;
    if i < Length(s) then
        posOfChar := i;
end;

function copy(s : longString; start, count : Integer): string;
var i : Integer;
begin
    copy := '';
    for i := start to start + count - 1 do
        copy := copy + s[i];
end;

function copy(s : longString; start : Integer): string;
var i : Integer;
begin
    copy := '';
    for i := start to Length(s)-1 do
        copy := copy + s[i];
end;

function stringToLongString(s : string): longString;
var i : Integer;
begin
    SetLength(stringToLongString, Length(s));
    for i := 0 to Length(s)-1 do
        stringToLongString[i] := s[i];
end;

function longStringToString(s : longString): string;
var i : Integer;
begin
    longStringToString := '';
    for i :=  0 to Length(s)-1 do
        longStringToString := longStringToString + s[i];
end;
end.