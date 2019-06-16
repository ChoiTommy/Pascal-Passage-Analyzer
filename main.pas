program main;
uses crt, ui;
const title_art_path = 'Text files/title.txt';
	  window_width = 120;

function getWindowWidth:Integer;
var i : Integer;
begin
	GotoXY(1, 1);
	i := 1;
	while WhereX = i do
	begin
		Write('*');
		i := i + 1;
	end;
	ClrScr;
	getWindowWidth := i-1;
end;

procedure drawStartingScreen(x, y : Integer);
var t : text;
	s : string;
	i : Integer;
begin
	assign(t, title_art_path);
	reset(t);
	i := 0;
	while not(eof(t)) do
	begin
		ReadLn(t, s);
		GotoXY(x, y + i);
		Write(s);
		i := i + 1;
	end;
	Close(t);
end;

var screenWidth : Integer;

begin
	cursoroff;
	screenWidth := getWindowWidth;
	if screenWidth = window_width then
	begin
		drawStartingScreen(4, 4);
		drawButton(3, 15, 15, 5, 'kaito', False);
		drawButton(30, 15, 15, 5, 'kaito', True);
		drawButton(57, 15, 15, 5, 'kaito', False);
	end
	else
	begin
		GotoXY(10, 5);
		Write('For the best experience, please set the window''s width to ');
		Write(window_width);
		Write('.');
		GotoXY(10, 6);
		Write('Current window''s width is: ');
		Write(screenWidth);
	end;
	ReadLn;

end.
