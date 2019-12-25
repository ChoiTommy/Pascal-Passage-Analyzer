program main;
{*
 *           Pascal Passage Analyser
 * This program is created for analysing a passage
 * in a text file. Since the program is in its
 * early stage, its features are limited. It can
 * count the number of paragraphs, number of words,
 * number of sentences, reading time, number of
 * unique words in a passage. It can also count and
 * find a specific words in the passage.
 *}
//TODO set colors for buttons or background after finishing coding
uses crt, ui, stringListType, sysutils, longStringType, passageAnalyser, FastConsole;

const window_width = 120; //console window width
      window_height = 30; //console window height

      window1_startX = 1;
      window1_startY = 2;
      window1_endX = 74;
      window1_endY = 29;

      window2_startX = 75;
      window2_startY = 1;
      window2_endX = 120;
      window2_endY = 30;

var state, front, i : Integer;
    passage : longString; //array of characters storing the passage
    noOfSent, noOfWords : Integer;
    noOfCharString, noOfParaString, noOfSentString, noOfWordsString, readingTimeString, readingEaseScoreString, noOfUniqueWordsString : string;
    uniqueWords : stringList; //array list storing unique words
    a : passageArray;

procedure checkScreenWidthScreen(var state : Integer);
(*write and check WhereX at the same time to check if the screen width is 120*)
const banner_startX = (window_width - 62) div 2;
      banner_startY = 3;
      banner_path = 'Text files/banner.txt';

      msgbox_width = 116;
      msgbox_height = 24;
      msgbox_startX = 3;
      msgbox_startY = 2;
var screenWidth : Integer;
	screenWidthString : string;
begin
    screenWidth := getWindowWidth;
	if screenWidth <> window_width then
	begin
        cursoroff;
		Str(screenWidth, screenWidthString);
		drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, 'Please set your window to 120*30. Current width: ' + screenWidthString, -1);
        drawFromTxtFile(banner_startX, banner_startY, banner_path, False, True);
        ReadLn;
		state := -1; //exit
	end
    else state := 0; //advance to importTextFileScreen()
end;

procedure writePassage;
begin
    Window(window1_startX, window1_startY, window1_endX, window1_endY);
    ClrScr;
    GotoXY(1, 1);
    if Length(a) > window1_endY-window1_startY+1 then
    begin
        for i := 0 to window1_endY-window1_startY do
            WriteLn(a[i]);
        front := 0;
    end
    else
        for i := 0 to Length(a)-1 do
            WriteLn(a[i]);
end;

procedure importTextFileScreen(var state : Integer);
(*Let user to input the file name of the passage*)
const banner_startX = (window_width - 62) div 2;
      banner_startY = 3;
      banner_path = 'Text files/banner.txt';

      msgbox_width = 62;
      msgbox_height = 15;
      msgbox_startX = (window_width-msgbox_width) div 2;
      msgbox_startY = 12;
      //msgbox_text = 'Rename your file as test.txt or type your file name here.';

      inputbox_text = 'File name';
      inputbox_boxWidth = 32; //no. of characters to be shown in the inputbox
      inputbox_startX = (msgbox_width - (inputbox_boxWidth + Length(inputbox_text) + 2)) div 2 + msgbox_startX;
      inputbox_startY = msgbox_startY + msgbox_height div 4;
      inputbox_hint = 'default.txt';

      button_width = 10;
      button_height = 1;
      button_quit_startX = 60;
      button_quit_startY = 23;
      button_ok_startX = 74;
      button_ok_startY = button_quit_startY;

      valid_file_name_char = ['0'..'9', 'a'..'z', 'A'..'Z', '.', ' ', '/']; //characters that are allowed to type

var c : Char;
    cursorX, cursorY, buttonPos : Integer;
    fileExist : Boolean;
    t : Text;
	textFileName : string;
begin
    ClrScr;
	drawFromTxtFile(banner_startX, banner_startY, banner_path, False, False);
    drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, '', -1);
    drawInputBox(inputbox_startX, inputbox_startY, inputbox_boxWidth, inputbox_text, inputbox_hint, False);
    drawButton(button_quit_startX, button_quit_startY, button_width, button_height, 'Quit', 0);
    buttonPos := 1; //0: 'Quit' 1:'OK'
    drawButton(button_ok_startX, button_ok_startY, button_width, button_height, 'OK', 1);

    cursorX := inputbox_startX + Length(inputbox_text) + 3;
    cursorY := inputbox_startY + 1;
    GotoXY(cursorX, cursorY);
    textFileName := '';
    cursoron;
    repeat
        c := ReadKey;
        if c = #0 then
        begin
            c := ReadKey;
            if (c = #77) or (c = #75) then  //switch between quit and ok
            begin
                case buttonPos of
                    0: drawButton(button_quit_startX, button_quit_startY, button_width, button_height, 'Quit', 0);
                    1: drawButton(button_ok_startX, button_ok_startY, button_width, button_height, 'OK', 0);
                end;
                case c of
                    #75 : if buttonPos = 1 then buttonPos := 0;
                    #77 : if buttonPos = 0 then buttonPos := 1;
                end;
                case buttonPos of
                    0: drawButton(button_quit_startX, button_quit_startY, button_width, button_height, 'Quit', 1);
                    1: drawButton(button_ok_startX, button_ok_startY, button_width, button_height, 'OK', 1);
                end;
                GotoXY(cursorX, cursorY);
            end
        end
        else if (c in valid_file_name_char) and (Length(textFileName) < inputbox_boxWidth) then //TODO handle cases when length of typed text is greater than box width
        begin
            textFileName := textFileName + c;
            if (textFileName <> '') and (Length(textFileName) = 1) then
                drawInputBox(inputbox_startX, inputbox_startY, inputbox_boxWidth, inputbox_text, inputbox_hint, True);
            GotoXY(cursorX, cursorY);
            Write(c);
            cursorX := cursorX + 1;
        end
        else if (c = #8) and (Length(textFileName) > 0) then //backspace
        begin
            Delete(textFileName, Length(textFileName), 1);
            cursorX := cursorX - 1;
            GotoXY(cursorX, cursorY);
            if textFileName = '' then
                drawInputBox(inputbox_startX, inputbox_startY, inputbox_boxWidth, inputbox_text, inputbox_hint, False)
            else Write(' ');
            GotoXY(cursorX, cursorY);
        end;
    until c = #13;

    if buttonPos = 0 then state := -1 //quit
    else
    begin
        ClrScr;
        cursoroff;

        if textFileName = '' then textFileName := 'default.txt';
        fileExist := FileExists(textFileName);
        if fileExist then
        begin
            Assign(t, textFileName);
            Reset(t);
            readLongString(t, passage);
            Close(t);

            //generating statistics
            noOfWords := countNoOfWords(passage);
            noOfSent := countNoOfSentences(passage);
            Str(countNoOfChar(passage), noOfCharString);
            Str(countNoOfPara(passage), noOfParaString);
            Str(noOfSent, noOfSentString);
            Str(noOfWords, noOfWordsString);
            readingTimeString := generateReadingTime(noOfWords);
            Str(generateReadingEaseScore(passage, noOfWords, noOfSent):4:2, readingEaseScoreString);
            uniqueWords := getListOfUniqueWords(passage);
            Str(size(uniqueWords), noOfUniqueWordsString);
            generateUniqueWordsTxtFile(uniqueWords);
            ClrScr;
            setScreenWidth(73);
            splitLongStringToArray(passage, a);
            writePassage;
            state := 1; //advance to mainScreen()
        end
        else
        begin
            drawFromTxtFile(banner_startX, banner_startY, banner_path, False, False);
            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, textFileName + ' not found. Press Enter to exit.', -1); //TODO add two more buttons here
            state := -1; //exit
            readln;
        end;
    end;
end;

procedure mainScreen(var state : Integer);
(*two windows*)
const banner_startX = 2; //2nd window
      banner_startY = 1;
      banner_path = 'Text files/mainScreenBanner.txt';

      button_stats_width = 23;
      button_stats_height = 5;
      button_stats_startX = 12; //2nd window
      button_stats_startY = 8;
      button_stats_text = 'Stats';

      button_find_width = button_stats_width;
      button_find_height = button_stats_height;
      button_find_startX = 12; //2nd window
      button_find_startY = 18;
      button_find_text = 'Find';

      button_settings_width = 15;
      button_settings_height = 1;
      button_settings_startX = 7; //2nd window
      button_settings_startY = 27;
      button_settings_text = 'Settings';

      button_quit_width = 15;
      button_quit_height = 1;
      button_quit_startX = 27; //2nd window
      button_quit_startY = 27;
      button_quit_text = 'Quit';

var position : Integer;
    c : Char;
begin
    //2nd window
    Window(window2_startX, window2_startY, window2_endX, window2_endY);
    ClrScr;
    cursoroff;
    drawFromTxtFile(banner_startX, banner_startY, banner_path, True, False);
    position := 1;
    drawButton(button_stats_startX, button_stats_startY, button_stats_width, button_stats_height, button_stats_text, 1);
    drawButton(button_find_startX, button_find_startY, button_find_width, button_find_height, button_find_text, 0);
    drawButton(button_settings_startX, button_settings_startY, button_settings_width, button_settings_height, button_settings_text, 0);
    drawButton(button_quit_startX, button_quit_startY, button_quit_width, button_quit_height, button_quit_text, 0);

    repeat
	  	c := ReadKey;
		if c = #0 then
		begin
			c := ReadKey;
			if (c = #72) or (c = #80) then
			begin
                Window(window2_startX, window2_startY, window2_endX, window2_endY);
				case position of
					1 : drawButton(button_stats_startX, button_stats_startY, button_stats_width, button_stats_height, button_stats_text, 0);
                    2 : drawButton(button_find_startX, button_find_startY, button_find_width, button_find_height, button_find_text, 0);
                    3 : drawButton(button_settings_startX, button_settings_startY, button_settings_width, button_settings_height, button_settings_text, 0);
                    4 : drawButton(button_quit_startX, button_quit_startY, button_quit_width, button_quit_height, button_quit_text, 0);
				end;
				case c of
                    #72 : if position = 1 then position := 4 else position := position - 1;
                    #80 : if position = 4 then position := 1 else position := position + 1;
				end;
				case position of
					1 : drawButton(button_stats_startX, button_stats_startY, button_stats_width, button_stats_height, button_stats_text, 1);
                    2 : drawButton(button_find_startX, button_find_startY, button_find_width, button_find_height, button_find_text, 1);
                    3 : drawButton(button_settings_startX, button_settings_startY, button_settings_width, button_settings_height, button_settings_text, 1);
                    4 : drawButton(button_quit_startX, button_quit_startY, button_quit_width, button_quit_height, button_quit_text, 1);
				end;
			end
            else if (c = #81) and (Length(a) > window1_endY-window1_startY+1) and (front + window1_endY-window1_startY < Length(a)-1) then
            begin
                Window(window1_startX, window1_startY, window1_endX, window1_endY);
                GotoXY(1, 1);
                DelLine;
                front := front + 1;
                GotoXY(1, window1_endY-1);
                Write(a[front + 27]);
            end
            else if (c = #73) and (Length(a) > window1_endY-window1_startY+1) and (front > 0) then
            begin
                Window(window1_startX, window1_startY, window1_endX, window1_endY);
                GotoXY(1, 1);
                InsLine;
                front := front - 1;
                Write(a[front]);
            end;
		end;
	until c = #13;
    Window(window2_startX, window2_startY, window2_endX, window2_endY);
    case position of
		1 : drawButton(button_stats_startX, button_stats_startY, button_stats_width, button_stats_height, button_stats_text, 2);
        2 : drawButton(button_find_startX, button_find_startY, button_find_width, button_find_height, button_find_text, 2);
        3 : drawButton(button_settings_startX, button_settings_startY, button_settings_width, button_settings_height, button_settings_text, 2);
        4 : drawButton(button_quit_startX, button_quit_startY, button_quit_width, button_quit_height, button_quit_text, 2);
	end;
    Delay(300); //animation
    case position of
		1 : drawButton(button_stats_startX, button_stats_startY, button_stats_width, button_stats_height, button_stats_text, 1);
        2 : drawButton(button_find_startX, button_find_startY, button_find_width, button_find_height, button_find_text, 1);
        3 : drawButton(button_settings_startX, button_settings_startY, button_settings_width, button_settings_height, button_settings_text, 1);
        4 : drawButton(button_quit_startX, button_quit_startY, button_quit_width, button_quit_height, button_quit_text, 1);
	end;
    Delay(200);
    cursoron;
    state := position + 1;
end;

procedure statsScreen(var state : Integer);
(*show some basic statistics of the passage*)
(*A banner is missing currently*)
const title_path = 'Text files/stats_title.txt';
      margin = 1;
      tab_width = 21;
      tab_height = 3;
      tab_startX = 18;
      tab_startY = 7;

      msgbox_width = tab_width;
      msgbox_height = 12;
      msgbox_startX = tab_startX;
      msgbox_startY = 6 + tab_height + 3;

var position: Integer;
    c : Char;
begin
    Window(window2_startX, window2_startY, window2_endX, window2_endY);
    ClrScr;
    cursoroff;
    //drawFromTxtFile(1, 1, title_path); //TODO find a new ascii art

    position := 1;
    drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of char');
    drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfCharString, -1);

    repeat
	  	c := ReadKey;
		if c = #0 then
		begin
			c := ReadKey;
			if (c = #75) or (c = #77) then
			begin
                Window(75, 1, 120, 30);
				case c of
					#75 : if position = 1 then position := 7 else position := position - 1;
					#77 : if position = 7 then position := 1 else position := position + 1;
				end;
				case position of
					1 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of char');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfCharString, -1);
                        end;
                    2 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of para');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfParaString, -1);
                        end;
                    3 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of sent');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfSentString, -1);
                        end;
                    4 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of words');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfWordsString, -1);
                        end;
                    5 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'Reading time');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, readingTimeString, -1);
                        end;
                    6 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'Reading score');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, readingEaseScoreString, -1);
                        end;
                    7 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of unique words');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfUniqueWordsString, -1);
                        end;
				end;
			end
            else if (c = #81) and (Length(a) > window1_endY-window1_startY+1) and (front + window1_endY-window1_startY < Length(a)-1) then
            begin
                Window(window1_startX, window1_startY, window1_endX, window1_endY);
                GotoXY(1, 1);
                DelLine;
                front := front + 1;
                GotoXY(1, window1_endY-1);
                WriteLn(a[front + 27]);
            end
            else if (c = #73) and (Length(a) > window1_endY-window1_startY) and (front > 0) then
            begin
                Window(window1_startX, window1_startY, window1_endX, window1_endY);
                GotoXY(1, 1);
                InsLine;
                front := front - 1;
                WriteLn(a[front]);
            end;
		end;
	until c = #27;
    state := 1;
end;

procedure findScreen(var state : Integer); //not yet finished, still in old version
(*
 * Find and highlight a specific word
 * TODO: rewrite it to search not just only a word, maybe a phrase
 *)
const title_path = 'Text files/find_title.txt';
      inputbox_startX = 3; //window 2
      inputbox_startY = 3;
      inputbox_boxWidth = 20;
      inputbox_description = 'Target';
      valid_search_target = ['a'..'z', 'A'..'Z', '0'..'9', ',', '''', '.', ' '];
      msgbox_width = Length(inputbox_description) + inputbox_boxWidth + 4;
      msgbox_height = 15;
      msgbox_startX = inputbox_startX;
      msgbox_startY = inputbox_startY + 3 + 1;

var target, occurrenceString : string;
    cursorX, cursorY, occurrence : Integer;
    c : Char;
    positionInLongString : IntegerArray;

begin

    repeat
        Window(window2_startX, window2_startY, window2_endX, window2_endY);
        ClrScr;
        cursoroff;

        drawInputBox(inputbox_startX, inputbox_startY, inputbox_boxWidth, inputbox_description, '', False);
        drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, 'Type a word to search.', -1);

        cursoron;
        target := '';
        SetLength(positionInLongString, 0);
        cursorX := inputbox_startX + Length(inputbox_description) + 3;
        cursorY := inputbox_startY + 1;
        GotoXY(cursorX, cursorY);
        repeat
            c := ReadKey;
            if c = #0 then
            begin
                c := ReadKey;
                cursoroff;
                if (c = #81) and (Length(a) > window1_endY-window1_startY+1) and (front + window1_endY-window1_startY < Length(a)-1) then
                begin
                    Window(window1_startX, window1_startY, window1_endX, window1_endY);
                    GotoXY(1, 1);
                    DelLine;
                    front := front + 1;
                    GotoXY(1, window1_endY-1);
                    WriteLn(a[front + 27]);
                end
                else if (c = #73) and (Length(a) > window1_endY-window1_startY) and (front > 0) then
                begin
                    Window(window1_startX, window1_startY, window1_endX, window1_endY);
                    GotoXY(1, 1);
                    InsLine;
                    front := front - 1;
                    WriteLn(a[front]);
                end;
                cursoron;
                Window(window2_startX, window2_startY, window2_endX, window2_endY);
                GotoXY(cursorX, cursorY);
            end
            else if (c in valid_search_target) and (Length(target) < inputbox_boxWidth) then //TODO handle cases when length of typed text is greater than box width
            begin
                target := target + c;
                GotoXY(cursorX, cursorY);
                Write(c);
                cursorX := cursorX + 1;
            end
            else if (c = #8) and (Length(target) > 0) then //backspace
            begin
                Delete(target, Length(target), 1);
                cursorX := cursorX - 1;
                GotoXY(cursorX, cursorY);
                Write(' ');
                GotoXY(cursorX, cursorY);
            end;
        until (c = #13) and (target <> '') or (c = #27);
        cursoroff;
        if (c = #13) and (target <> '') then //find algorithm
        begin
            positionInLongString := posOfString(target, passage);
            ClrScr;
            for i := 0 to Length(positionInLongString)-1 do
            begin
                GotoXY(1, i + 1);
                Write(positionInLongString[i]);
            end;
            ReadLn;
        end;


    until c = #27;

    {Window(1, 1, window_width, window_height);
    ClrScr;
    drawFromTxtFile(1, 1, title_path, True, False);
    setScreenWidth(85);
    repeat
        writeLongString(7, passage, '', occurrence);
        drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, 'Type a word to search.', -1);
        drawInputBox(inputbox_startX, inputbox_startY, inputbox_width, inputbox_description, '', False);
        cursoron;
        target := '';
        cursorX := inputbox_startX + Length(inputbox_description);
        cursorY := inputbox_startY;
        repeat
            c := ReadKey;
            if c = #0 then c := ReadKey
            else if (c in valid_search_target) and (Length(target) < inputbox_width) then
            begin
                target := target + c;
                GotoXY(cursorX, cursorY);
                Write(c);
                cursorX := cursorX + 1;
            end
            else if (c = #8) and (Length(target) > 0) then
            begin
                Delete(target, Length(target), 1);
                cursorX := cursorX - 1;
                GotoXY(cursorX, cursorY);
                Write(' ');
                GotoXY(cursorX, cursorY);
            end;
        until (c = #13) and (target <> '') or (c = #27);
        cursoroff;
        if c = #13 then
        begin
            writeLongString(7, passage, target, occurrence);
            Str(occurrence, occurrenceString);
            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, occurrenceString + ' occurrence(s)', -1);
            c := ReadKey;
            if c = #0 then c := ReadKey;
        end;
    until c = #27;
    ClrScr;
    writePassage;}
    state := 1;
end;

procedure settingsScreen(var state: Integer);
begin
    ClrScr;
    WriteLn('under construction');
    ReadLn;
    state := 1;
end;

begin
    checkScreenWidthScreen(state);
    repeat
	  	case state of
		    0 : importTextFileScreen(state);
            1 : mainScreen(state);
            2 : statsScreen(state);
            3 : findScreen(state);
            4 : settingsScreen(state);
		end;
	until (state = 5) or (state = -1);
end.