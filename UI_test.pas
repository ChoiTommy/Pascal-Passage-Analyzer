program UI_test;
uses crt;
const default_textbackground = Black;
      default_textcolor = LightGray;
      button_textbackground_unselected = LightGray;
      button_textbackground_selected = Red;
      button_textcolor_unselected = Black;
      button_textcolor_selected = Green;
(*TODO
* text color, print character, ...
* button border
*)
procedure drawButton(startX, startY, width, height : integer; s : string; selected : Boolean);
//recommendation : all -> odd;
var i, j, x, y : integer;
    text, background : Byte;
begin
    x := (width div 2 - Length(s) div 2) + 1;
    y := height div 2 + 1;
    if selected then
    begin
        text := button_textcolor_selected;
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
        begin
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
        end;
        WriteLn;
    end;
    TextBackground(default_textbackground);
    TextColor(default_textcolor);
end;

procedure drawMsgBox(startX, startY, width, height : integer);
begin

end;

procedure drawColorBlock();
begin

end;

begin
    drawButton(2, 2, 7, 3, '123', False);
    drawButton(2, 8, 7, 3, '456', True);
    drawButton(2, 14, 7, 3, '789', False);
    ReadLn;
end.