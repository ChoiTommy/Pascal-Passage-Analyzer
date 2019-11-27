program UI_test;
uses crt, FastConsole, ui;
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

(*TODO
* seleted colors, ...
*)

{procedure resetDefaultColor(text, background: Boolean);
begin
    if text then TextColor(default_textcolor);
    if background then TextBackground(default_textbackground);
end;

procedure drawButton(startX, startY, width, height : integer; s : string; selected : Boolean);
//recommendation : all -> odd;
var i, j, x, y : integer;
    temp : string;
begin
    x := (width div 2 - Length(s) div 2) + 1;
    y := height div 2 + 1;
    if selected then
    begin
        TextColor(button_textcolor_selected);
        TextBackground(button_textbackground_selected);
    end
    else
    begin
        TextColor(button_textcolor_unselected);
        TextBackground(button_textbackground_unselected);
    end;
    for i := 1 to height do
    begin
        GotoXY(startX, startY + i - 1);
        temp := '';
        j := 1;
        while j <= width do
        begin
            if (y = i) and (x = j) then
            begin
                temp := temp + s;
                j := j + Length(s);
            end
            else
            begin
                temp := temp + ' ';
                j := j + 1;
            end;
        end;
        Write(temp);
    end;
    resetDefaultColor(True, True);
end;

procedure drawMsgBox(startX, startY, width, height : integer; message : string);
//just a msgbox with no buttons, create buttons : drawButton();
var i, j, x, y : Integer;
    temp : string;
begin
    TextColor(msgbox_textcolor);
    TextBackground(msgbox_background_color);
    x := (width div 2 - Length(message) div 2) + 1;
    y := height div 2;
    for i := 1 to height do
    begin
        GotoXY(startX, startY + i - 1);
        temp := '';
        j := 1;
        while j <= width do
        begin
            if (i = 1) or (i = height) or (j = 1) or (j = width) then
            begin
                temp := temp + msgbox_border_char;
                j := j + 1;
            end
            else if (x = j) and (y = i) then
            begin
                temp := temp + message;
                j := j + Length(message);
            end
            else
            begin
                temp := temp + ' ';
                j := j + 1;
            end;
        end;
        Write(temp);
    end;
    resetDefaultColor(True, True);
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
end;}

begin
    cursoroff;
    {drawButton(2, 2, 70, 20, 'Nerd', False);
    Readln;
    drawButton(2, 2, 70, 20, 'Nerd', True);
    drawMsgBox(5, 3, 50, 11, 'Are you nerd?');
    drawButton(5+5, 3+11-3, 5, 1, 'Yes', False);
    drawButton(5+5+33, 3+11-3, 5, 1, 'No', True);
    drawCheckBox(5, 20, 'I''m nerd.', True, False);}

    drawButton(3, 3, 10, 1, 'ABCD', False);

    ReadLn;
end.