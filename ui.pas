unit ui;

interface
uses crt;
const default_textbackground = Black;
      default_textcolor = LightGray;
      button_textbackground_unselected = LightGray;
      button_textbackground_selected = Red;
      button_textcolor_unselected = Black;
      button_textcolor_selected = LightGray;
      msgbox_background_color = LightGray;
      msgbox_textcolor = Black;
      msgbox_border_char = '*';
      checkbox_textcolor_selected = Black;
      checkbox_textbackground_selected = LightGray;
      checkbox_textcolor_unselected = default_textcolor;
      checkbox_textbackground_unselected = default_textbackground;

procedure drawButton(startX, startY, width, height : integer; s : string; selected : Boolean);
procedure drawMsgBox(startX, startY, width, height : integer; message : string);
procedure drawFromTxtFile(startX, startY : Integer; path : string);
function getWindowWidth : Integer;
procedure drawCheckBox(startX, startY : Integer; description : string; selected, checked : Boolean);

implementation

procedure resetDefaultColor(text, background: Boolean);
begin
    if text then TextColor(default_textcolor);
    if background then TextBackground(default_textbackground);
end;

procedure drawButton(startX, startY, width, height : integer; s : string; selected : Boolean);
var i, j, x, y : integer;
    text, background : Byte;
begin
    x := (width div 2 - Length(s) div 2) + 1;
    y := height div 2 + 1;
    if selected then
    begin
        text := button_textcolor_selected; //todo
        background := button_textbackground_selected;
    end
    else
    begin
        text := button_textcolor_unselected;
        background := button_textbackground_unselected;
    end;
    for i := 1 to height do
    begin
        GotoXY(startX, startY + i - 1);
        j := 1;
        while j <= width do
            if (y = i) and (x = j) then
            begin
                TextBackground(background);
                TextColor(text);
                Write(s);
                j := j + Length(s);
            end
            else
            begin
                TextBackground(background);
                Write(' ');
                j := j + 1;
            end;
        WriteLn;
    end;
    TextBackground(default_textbackground);
    TextColor(default_textcolor);
end;

procedure drawMsgBox(startX, startY, width, height : integer; message : string);
var i, j, x, y : Integer;
begin
    TextColor(msgbox_textcolor);
    TextBackground(msgbox_background_color);
    x := (width div 2 - Length(message) div 2) + 1;
    y := height div 2;
    for i := 1 to height do
    begin
        GotoXY(startX, startY + i - 1);
        j := 1;
        while j <= width do
            if (i = 1) or (i = height) or (j = 1) or (j = width) then
            begin
                Write(msgbox_border_char);
                j := j + 1;
            end
            else if (x = j) and (y = i) then
            begin
                Write(message);
                j := j + Length(message);
            end
            else
            begin
                Write(' ');
                j := j + 1;
            end;
    end;
    resetDefaultColor(True, True);
end;

procedure drawFromTxtFile(startX, startY : Integer; path : string);
var t : Text;
    i : Integer;
    s : string;
begin
    assign(t, path);
	reset(t);
	i := 0;
	while not(eof(t)) do
	begin
		ReadLn(t, s);
		GotoXY(startX, startY + i);
		Write(s);
		i := i + 1;
	end;
	Close(t);
end;

function getWindowWidth : Integer;
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

procedure drawCheckBox(startX, startY : Integer; description : string; selected, checked : Boolean);
begin
    if selected then
    begin
        TextColor(checkbox_textcolor_selected);
        TextBackground(checkbox_textbackground_selected);
    end
    else
    begin
        TextColor(checkbox_textcolor_unselected);
        TextBackground(checkbox_textbackground_unselected);
    end;
    GotoXY(startX, startY);
    if checked then
        Write('[*]' + '   ' + description)
    else
        Write('[ ]' + '   ' + description);
    resetDefaultColor(True, True);
end;

end.