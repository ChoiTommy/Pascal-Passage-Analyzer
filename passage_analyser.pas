program passage_analyser;
(*
 * -1 : exit
 * 0 : file name input screen
 * 1 : main screen
 *)
uses crt, ui, FastConsole, stringListType, sysutils, longStringType;

const window_width = 120;
      window_height = 30;

var state : Integer;
    passage : longString;
    textFileName : string;

procedure checkScreenWidthScreen(var state : Integer);
var screenWidth : Integer;
begin
    cursoroff;
    ClrScr;
    screenWidth := getWindowWidth;
	if screenWidth <> window_width then
	begin
        //todo rewrite it using ui components
		GotoXY(10, 5);
		Write('For the best experience, please set the window''s width to ');
		Write(window_width);
		Write('.');
		GotoXY(10, 6);
		Write('Current window''s width is: ');
		Write(screenWidth);
		state := -1; //exit
	end
    else
        state := 0;
end;

procedure importTextFileScreen(var state : Integer);
const msgbox_width = 70;
      msgbox_height = 20;
      msgbox_startX = (window_width-msgbox_width) div 2;
      msgbox_startY = (window_height-msgbox_height) div 2;
      inputbox_text = 'File name: ';
      inputbox_width = 20;
      inputbox_startX = (msgbox_width - (inputbox_width + Length(inputbox_text))) div 2 + msgbox_startX;
      inputbox_startY = msgbox_startY + msgbox_height div 2  + msgbox_height div 4;
      valid_file_name_char = ['0'..'9', 'a'..'z', 'A'..'Z', '.'];
var c : Char;
    cursorX, cursorY : Integer;
    fileExist : Boolean;
    t : Text;
begin
    ClrScr;
    drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, 'Rename your file as test.txt or type the file name here.');
    drawInputBox(inputbox_startX, inputbox_startY, inputbox_width, inputbox_text);
    cursorX := inputbox_startX + Length(inputbox_text);
    cursorY := inputbox_startY;
    textFileName := '';
    cursoron;
    repeat
        c := ReadKey;
        if (c in valid_file_name_char) and (Length(textFileName) < inputbox_width) then
        begin
            textFileName := textFileName + c;
            GotoXY(cursorX, cursorY);
            Write(c);
            cursorX := cursorX + 1;
        end
        else if (c = #8) and (Length(textFileName) > 0) then
        begin
            Delete(textFileName, Length(textFileName), 1);
            cursorX := cursorX - 1;
            GotoXY(cursorX, cursorY);
            Write(' ');
            GotoXY(cursorX, cursorY);
        end;
    until c = #13;
    ClrScr;
    cursoroff;

    if textFileName = '' then textFileName := 'test.txt';
	fileExist := FileExists(textFileName);
    if fileExist then
    begin
        drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, 'Analysing passage ' + textFileName);
        Assign(t, textFileName);
		Reset(t);
		readLongString(t, passage);
        Close(t);
        state := 1;
    end
    else
    begin
        drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, textFileName + ' not found.');
        state := -1;
        ReadLn;
    end;
end;

procedure mainScreen(var state : Integer);
(*Stats, Find, settings, exit*)
const title_art_path = 'Text files/title.txt';
//Todo relocate these buttons
      button_function_button_width = 15;
      button_function_button_height = 5;
      button_stats_startX = 10;
      button_stats_startY = 15;
      button_find_startX = 3 + button_function_button_width + 20;
      button_find_startY = button_stats_startY;

      button_secondary_button_width = 13;
      button_secondary_button_height = 1;
      button_settings_startX = 15;
      button_settings_startY = button_stats_startY + button_function_button_height + 3;
      button_exit_startX = button_settings_startX + button_secondary_button_width + 20;
      button_exit_startY = button_settings_startY;
var c : char;
	position : Integer;
begin
    ClrScr;
    drawFromTxtFile(1, 1, title_art_path);

	position := 1; //selected the first button
    drawButton(button_stats_startX, button_stats_startY, button_function_button_width, button_function_button_height, 'Stats', True);
	drawButton(button_find_startX, button_find_startY, button_function_button_width, button_function_button_height, 'Find', False);
	drawButton(button_settings_startX, button_settings_startY, button_secondary_button_width, button_secondary_button_height, 'Settings', False);
    drawButton(button_exit_startX, button_exit_startY, button_secondary_button_width, button_secondary_button_height, 'Exit', False);
    GotoXY(90, 7);
    Write('Current text file: ', textFileName);

    repeat
	  	c := ReadKey;
		if c = #0 then
		begin
			c := ReadKey;
			if (c = #77) or (c = #75) then
			begin
				case position of
					1 : drawButton(button_stats_startX, button_stats_startY, button_function_button_width, button_function_button_height, 'Stats', False);
                    2 : drawButton(button_find_startX, button_find_startY, button_function_button_width, button_function_button_height, 'Find', False);
	                3 : drawButton(button_settings_startX, button_settings_startY, button_secondary_button_width, button_secondary_button_height, 'Settings', False);
                    4 : drawButton(button_exit_startX, button_exit_startY, button_secondary_button_width, button_secondary_button_height, 'Exit', False);
				end;
				case c of
					#77 : if position = 4 then position := 1 else position := position + 1;
					#75 : if position = 1 then position := 4 else position := position - 1;
				end;
				case position of
					1 : drawButton(button_stats_startX, button_stats_startY, button_function_button_width, button_function_button_height, 'Stats', True);
                    2 : drawButton(button_find_startX, button_find_startY, button_function_button_width, button_function_button_height, 'Find', True);
	                3 : drawButton(button_settings_startX, button_settings_startY, button_secondary_button_width, button_secondary_button_height, 'Settings', True);
                    4 : drawButton(button_exit_startX, button_exit_startY, button_secondary_button_width, button_secondary_button_height, 'Exit', True);
				end;
			end;

		end;
	until c = #13;

	Write(position);
    ReadLn;
    state := -1;
end;

begin
    checkScreenWidthScreen(state);
    repeat
	  	case state of
		    0 : importTextFileScreen(state);
            1 : mainScreen(state);
		end;
	until state = -1;
    ClrScr;
    GotoXY(1, 1);
    Write('Bye!');
    //setScreenWidth(window_width);
    //writeLongString(passage);
    ReadLn;
end.