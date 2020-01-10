unit longStringType;

interface
uses crt;
type longString = array of Char;
     passageArray = array of string;
     integerArray = array of Integer;

procedure readLongString(var s : longString);
procedure readLongString(var t : Text; var s : longString);
function countInLongString(c : Char; s : longString) : Integer;
function countInLongString(t : string; s : longString) : Integer;
function posOfChar(c : char; s : longString) : Integer;
function posOfString(sub: string; long : longString): integerArray;
function copy(s : longString; start, count : Integer): string;
function copy(s : longString; start : Integer): string;
function castStringToLongString(s : string): longString;
function castLongStringToString(s : longString): string;
procedure setScreenWidth(a : Integer);
function getScreenWidth: Integer;
procedure splitLongStringToArray(s : longString; var a : passageArray);
procedure writeLongString(startY : Integer; s : longString; target : string; var n : Integer);

implementation
const words_set = ['A'..'Z', 'a'..'z', '0'..'9'];
      default_textbackground = Black;
      default_textcolor = LightGray;
      highlighted_textbackground = Yellow;
      highlighted_textcolor = Black;
var screen_width : Integer;

procedure readLongString(var s : longString);
(*Read long string in console*)
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
(*Read long string in a text file*)
(*now hard coded, needed to be rewritten*)
var n : Integer;
    c : Char;
begin
    n := 0;
    while not EOF(t) do
    begin
        Read(t, c);
        if c = #13 then
        begin
            n := n + 2;
            SetLength(s, n);
            s[n-2] := #13;
            s[n-1] := #10;
            while (c = #13) or (c = #10) do
                Read(t, c);
            n := n + 1;
            SetLength(s, n);
            s[n-1] := c;
        end
        else
        begin
            n := n + 1;
            SetLength(s, n);
            s[n-1] := c;
        end;
    end;
end;

function countInLongString(c : Char; s : longString) : Integer;
(*Count the no. of occurrance of a character in a long string*)
var i : Integer;
begin
    countInLongString := 0;
    for i := 0 to Length(S)-1 do
        if lowerCase(s[i]) = lowerCase(c) then
            countInLongString := countInLongString + 1;
end;

function countInLongString(t : string; s : longString) : Integer;
(*Count the no. of occurrance of a string in a long string*)
var i, j : Integer;
    temp : string;
begin
    countInLongString := 0;
    for i := 0 to Length(s)-1 do
    begin
        temp := '';
        for j := 1 to Length(t) do
            temp := temp + s[i+j-1];
        if lowerCase(t) = lowerCase(temp) then
            countInLongString := countInLongString + 1;
    end;
end;

function posOfChar(c : char; s : longString) : Integer;
(*Get the position of a character in a long string (0-based)*)
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
(*Extract a certain no. of a characters from the starting position in a long string*)
var i : Integer;
begin
    copy := '';
    for i := start to start + count - 1 do
        copy := copy + s[i];
end;

function copy(s : longString; start : Integer): string;
(*Extract a characters from the starting position to the end in a long string*)
var i : Integer;
begin
    copy := '';
    for i := start to Length(s)-1 do
        copy := copy + s[i];
end;

function castStringToLongString(s : string): longString;
(*Type casting*)
var i : Integer;
begin
    SetLength(castStringToLongString, Length(s));
    for i := 0 to Length(s)-1 do
        castStringToLongString[i] := s[i];
end;

function castLongStringToString(s : longString): string;
(*Type casting (Maximum limit of characters : 255)*)
var i : Integer;
begin
    castLongStringToString := '';
    for i :=  0 to Length(s)-1 do
        castLongStringToString := castLongStringToString + s[i];
end;

procedure setScreenWidth(a : Integer);
(*Initialization of this unit (mainly for the procedure writeLongString()*)
begin
    screen_width := a;
end;

procedure splitLongStringToArray(s : longString; var a : passageArray);
(*
 * Split long string to an array of string with max length = screen_width
 * Current problems:
 * Only words are being considered in word wrapping,
 * other words such as emails (treated as one word)
 * will be seperated at the end of the line.
 * It can only start printing at (1, startY) for my
 * convenience.
 *)
var i, x, n : Integer;
    temp : string;
begin
    i := 0;
    temp := '';
    n := 1;
    SetLength(a, n);
    a[n-1] := '';
    while i < Length(s) do
    begin
        if (s[i] in words_set) then
            temp := temp + s[i]
        else if not(s[i] in [#13, #10]) then
        begin
            x := Length(a[n-1]) - 1;
            if x + Length(temp) >= screen_width then
            begin
                n := n + 1;
                SetLength(a, n);
                a[n-1] := '';
            end;
            a[n-1] := a[n-1] + temp + s[i];
            temp := '';
        end
        else if (s[i] = #13) and (s[i+1] = #10) then
        begin
            n := n + 2;
            SetLength(a, n);
            a[n-2] := '  ';
        end;
        i := i + 1;
    end;
end;

procedure writeLongString(startY : Integer; s : longString; target : string; var n : Integer);
(*write the longString and highlight the target words*)
//TODO need to be rewritten
var i, x: Integer;
    temp : string;
begin
    i := 0;
    n := 0;
    GotoXY(1, startY);
    temp := '';
    while i < Length(s) do
    begin
        if (s[i] in words_set) then
            temp := temp + s[i]
        else if not(s[i] in [#13, #10]) then
        begin
            x := WhereX - 1;
            if (lowerCase(target) = lowerCase(temp)) and (temp <> '') then
            begin
                n := n + 1;
                TextColor(highlighted_textcolor);
                TextBackground(highlighted_textbackground);
            end;
            if x + Length(temp) > screen_width then
            begin
                WriteLn;
                Write(temp);
            end
            else Write(temp);
            TextColor(default_textcolor);
            TextBackground(default_textbackground);
            Write(s[i]);
            temp := '';
        end
        else if (s[i] = #13) and (s[i+1] = #10) then
        begin
            WriteLn;
            WriteLn;
        end;
        i := i + 1;
    end;
end;

function posOfString(sub: string; long: longString): integerArray;
(*return position of substring in longstring (0-based)*)
var i, j, n, temp : Integer;
begin
    posOfString := Nil;
    n := 0;
    for i := 0 to Length(long)-Length(sub) do
    begin
        j := 1;
        temp := i;
        while (sub[j] = long[temp]) and (j <= Length(sub)) do
        begin
            j := j + 1;
            temp := temp + 1;
        end;
        if j-1 = Length(sub) then
        begin
            n := n + 1;
            SetLength(posOfString, n);
            posOfString[n-1] := i;
        end;
    end;
end;

function getScreenWidth: Integer;
begin
    getScreenWidth := screen_width;
end;

end.