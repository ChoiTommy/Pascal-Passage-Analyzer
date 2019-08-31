unit longStringType;

interface
uses crt;
type longString = array of Char;
procedure readLongString(var s : longString);
procedure readLongString(var t : Text; var s : longString);
function countInLongString(c : Char; s : longString) : Integer;
function countInLongString(t : string; s : longString) : Integer;
function posOfChar(c : char; s : longString) : Integer;
function copy(s : longString; start, count : Integer): string;
function copy(s : longString; start : Integer): string;
function castStringToLongString(s : string): longString;
function castLongStringToString(s : longString): string;
procedure setScreenWidth(a : Integer);
procedure writeLongString(s : longString);
procedure writeLongString(s : longString; target : string; var n : Integer);

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

procedure writeLongString(s : longString);
(* Write long string in passage format in the console
 * Current problems:
 * Only words are being considered in word wrapping,
 * other words such as emails (treated as one word)
 * will be seperated at the end of the line.
 *)
var i, x : Integer;
    temp : string;
begin
    i := 0;
    temp := '';
    while i < Length(s) do
    begin
        if (s[i] in words_set) then
            temp := temp + s[i]
        else if not(s[i] in [#13, #10]) then
        begin
            x := WhereX;
            if x + Length(temp) > screen_width then
            begin
                WriteLn;
                Write(temp);
            end
            else Write(temp);
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

procedure writeLongString(s : longString; target : string; var n : Integer);
var i, x : Integer;
    temp : string;
begin
    i := 0;
    n := 0;
    temp := '';
    while i < Length(s) do
    begin
        if (s[i] in words_set) then
            temp := temp + s[i]
        else if not(s[i] in [#13, #10]) then
        begin
            x := WhereX;
            if lowerCase(target) = lowerCase(temp) then
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

end.