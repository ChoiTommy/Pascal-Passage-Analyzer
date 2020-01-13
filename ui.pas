unit ui;

interface
uses crt;
const default_textbackground = LightCyan;
      default_textcolor = Black;

      custom_textbackground = LightMagenta;
      custom_textcolor = LightGray;

      //button colors
      button_textbackground_normal = 3;
      button_textbackground_normal_shadow = Blue;
      button_textcolor_normal = Black;
      button_textbackground_selected = Blue;
      button_textbackground_selected_shadow = LightBlue;
      button_textcolor_selected = LightGray;
      button_textbackground_clicked = button_textbackground_selected;
      button_textcolor_clicked = Black;

      //message box colors
      msgbox_textbackground = LightCyan;
      msgbox_textcolor = Black;

      //check box colors
      checkbox_textbackground_normal = Black;
      checkbox_textcolor_normal = LightGray;
      checkbox_textbackground_selected = LightGray;
      checkbox_textcolor_selected = Black;

      //input box colors
      inputbox_textbackground = LightCyan;
      inputbox_textcolor = Black;
      inputbox_textbackground_box = Black;
      inputbox_textcolor_input = LightGray;
      inputbox_textcolor_hint = Yellow;

      //tab colors
      tab_textbackground = LightCyan;
      tab_textcolor = Black;

      //draw ascii arts colors
      art_textbackground = LightGray;
      art_textcolor = Black;

procedure drawButton(startX, startY, width, height : integer; s : string; state : Integer);
procedure drawMsgBox(startX, startY, width, height : integer; message : string; messageY : Integer);
procedure drawFromTxtFile(startX, startY : Integer; path : string; withoutModification, invertedColors : Boolean);
function getWindowWidth : Integer;
procedure drawCheckBox(startX, startY : Integer; description : string; selected, checked : Boolean);
procedure drawInputBox(startX, startY: Integer; boxWidth: Integer; message, hint: string; typing : Boolean);
procedure drawTab(startX, startY, width, height : integer; s : string);
procedure setColors(a, b : Byte);
procedure resetDefaultColors(text, background: Boolean);

implementation

procedure resetDefaultColors(text, background: Boolean);
begin
    if text then TextColor(default_textcolor);
    if background then TextBackground(default_textbackground);
end;

procedure setColors(a, b : Byte);
begin
    TextBackground(a);
    TextColor(b)
end;

procedure drawButton(startX, startY, width, height : integer; s : string; state : Integer);
(* height is usually an odd number
 * states:
 * 0 : normal
 * 1 : selected
 * 2 : clicked
 *)
var i, j, x, y : integer;
begin
    HighVideo;
    x := width div 2 - Length(s) div 2;
    y := height div 2;
    GotoXY(startX, startY);
    if height = 1 then
    begin
        case state of
            0 : setColors(button_textbackground_normal, button_textcolor_normal);
            1 : setColors(button_textbackground_selected, button_textcolor_selected);
            2 : setColors(button_textbackground_clicked, button_textcolor_clicked);
        end;
        for i := 1 to width do
            Write(' ');
        GotoXY(startX + x, startY);
        Write(s);
    end
    else
        case state of
            0 : begin
                setColors(button_textbackground_normal, button_textcolor_normal);
                for i := 1 to height do
                begin
                    GotoXY(startX, startY+i-1);
                    for j := 1 to width do
                        Write(' ');
                end;
                GotoXY(startX + x, startY + y);
                Write(s);
                setColors(button_textbackground_normal_shadow, button_textcolor_normal);
                for i := startY + 1 to startY + height do
                begin
                    GotoXY(startX + width, i);
                    Write(' ');
                end;
                GotoXY(startX + 1, startY + height);
                for i := 1 to width - 1 do
                    Write(' ');
            end;
            1 : begin
                setColors(button_textbackground_selected, button_textcolor_selected);
                for i := 1 to height do
                begin
                    GotoXY(startX, startY+i-1);
                    for j := 1 to width do
                        Write(' ');
                end;
                GotoXY(startX + x, startY + y);
                Write(s);
                setColors(button_textbackground_selected_shadow, button_textcolor_selected);
                for i := startY + 1 to startY + height do
                begin
                    GotoXY(startX + width, i);
                    Write(' ');
                end;
                GotoXY(startX + 1, startY + height);
                for i := 1 to width - 1 do
                    Write(' ');
            end;
            2 : begin
                setColors(button_textbackground_clicked, button_textcolor_clicked);
                for i := 1 to height do
                begin
                    GotoXY(startX+1, startY+i);
                    for j := 1 to width do
                        Write(' ');
                end;
                GotoXY(startX + x + 1, startY + y + 1);
                Write(s);
                setColors(custom_textbackground, custom_textcolor);
                for i := startY to startY + height -1 do
                begin
                    GotoXY(startX, i);
                    Write(' ');
                end;
                GotoXY(startX + 1, startY);
                for i := 1 to width - 1 do
                    Write(' ');
            end;
        end;
    resetDefaultColors(True, True);
end;

procedure drawMsgBox(startX, startY, width, height : integer; message : string; messageY : Integer);
(*messageY : 0 to height-1 integer*)
var i, j, x, y : Integer;
begin
    cursoroff;
    setColors(msgbox_textbackground, msgbox_textcolor);
    for i := 1 to height do
    begin
        GotoXY(startX, startY + i - 1);
        for j := 1 to width do
            Write(' ');
    end;
    x := width div 2 - Length(message) div 2;
    if (messageY = -1) or (messageY > height-1) then y := height div 2
    else y := messageY;
    GotoXY(startX + x, startY + y);
    Write(message);
    resetDefaultColors(True, True);
end;

procedure drawFromTxtFile(startX, startY : Integer; path : string; withoutModification, invertedColors : Boolean);
(*Mainly use for drawing ASCII arts*)
var t : Text;
    i : Integer;
    c : Char;
begin
    assign(t, path);
	reset(t);
	i := 0;
    GotoXY(startX, startY);
	while not(eof(t)) do
	begin
        while not eoln(t) do
        begin
            Read(t, c);
            if (not withoutModification) and (c <> ' ') then
            begin
                if not invertedColors then setColors(art_textbackground, art_textcolor);
                Write(' ');
                if not invertedColors then setColors(custom_textbackground, custom_textcolor);
            end
            else
            begin
                if invertedColors then setColors(art_textbackground, art_textcolor);
                Write(c);
                if invertedColors then setColors(custom_textbackground, custom_textcolor);
            end;
        end;
        ReadLn(t);
		i := i + 1;
        GotoXY(startX, startY + i);
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
    cursoroff;
    if selected then
        setColors(checkbox_textbackground_selected, checkbox_textcolor_selected)
    else
        setColors(checkbox_textbackground_normal, checkbox_textcolor_normal);
    GotoXY(startX, startY);
    if checked then
        Write('[*]' + '   ' + description)
    else
        Write('[ ]' + '   ' + description);
    resetDefaultColors(True, True);
end;

procedure drawInputBox(startX, startY: Integer; boxWidth: Integer; message, hint: string; typing : Boolean);
var i, j : Integer;
begin
    cursoroff;
    setColors(inputbox_textbackground, inputbox_textcolor);
    if typing then hint := '';
    for i := 1 to 3 do
    begin
        GotoXY(startX, startY + i - 1);
        for j := 1 to 4 + Length(message) + boxWidth do
            Write(' ');
    end;
    GotoXY(startX+1, startY+1);
    Write(message + ': ');
    setColors(inputbox_textbackground_box, inputbox_textcolor_hint);
    Write(hint);
    for i := 1 to boxWidth - Length(hint) do
        Write(' ');
    resetDefaultColors(True, True);
    cursoron;
end;

procedure drawTab(startX, startY, width, height : Integer; s : string);
var i, j, x, y : integer;
begin
    cursoroff;
    setColors(tab_textbackground, tab_textcolor);
    for i := 1 to height do
    begin
        GotoXY(startX, startY - 1 + i);
        for j := 1 to width do
            Write(' ');
    end;
    x := width div 2 - Length(s) div 2;
    y := height div 2;
    GotoXY(startX, startY+y);
    Write('<');
    GotoXY(startX + width -1, startY+y);
    Write('>');
    GotoXY(startX+x, startY+y);
    Write(s);
    resetDefaultColors(True, True);
end;

end.