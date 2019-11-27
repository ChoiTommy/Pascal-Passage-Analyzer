program passage_analyser;
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
uses crt, ui, FastConsole, stringListType, sysutils, longStringType, passageAnalyser;

const window_width = 120; //console window width
      window_height = 30; //console window height

var state : Integer; //use it to switch screens
    passage : longString; //array of characters storing the passage
    textFileName : string;
    noOfSent, noOfWords : Integer;
    noOfCharString, noOfParaString, noOfSentString, noOfWordsString, readingTimeString, readingEaseScoreString, noOfUniqueWordsString : string;
    uniqueWords : stringList; //array list storing unique words

procedure checkScreenWidthScreen(var state : Integer);
(*write and check WhereX at the same time to check if the screen width is 120*)
var screenWidth : Integer;
begin
    cursoroff;
    ClrScr;
    screenWidth := getWindowWidth;
	if screenWidth <> window_width then
	begin
        //todo rewrite it using ui components
		GotoXY(10, 5);
		Write('For the best experience, please set the window''s width to ', window_width, '*', window_height, '.');
		GotoXY(10, 6);
		Write('Current window''s width is: ');
		Write(screenWidth);
        ReadLn;
		state := -1; //exit
	end
    else
        state := 0; //advance to importTextFileScreen
end;

procedure importTextFileScreen(var state : Integer);
(*Let user to input the file name of the passage*)
//TODO redesign ui
const msgbox_width = 70;
      msgbox_height = 20;
      msgbox_startX = (window_width-msgbox_width) div 2;
      msgbox_startY = (window_height-msgbox_height) div 2;
      msgbox_text = 'Rename your file as test.txt or type your file name here.';
      inputbox_text = 'File name: ';
      inputbox_width = 20; //no. of characters to be shown in the inputbox
      inputbox_startX = (msgbox_width - (inputbox_width + Length(inputbox_text))) div 2 + msgbox_startX;
      inputbox_startY = msgbox_startY + msgbox_height div 2  + msgbox_height div 4;
      valid_file_name_char = ['0'..'9', 'a'..'z', 'A'..'Z', '.', ' ', '/']; //characters that are allowed to type
      label_text = 'Just press enter if you passage file name is ''test.txt'' or you''ve finished typing.';
      label_startX = window_width div 2 - Length(label_text) div 2;
      label_startY = 28;
var c : Char;
    cursorX, cursorY : Integer;
    fileExist : Boolean;
    t : Text;
begin
    ClrScr;
    drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, msgbox_text, False, 'a');
    drawTextLabel(label_startX, label_startY, label_text);
    drawInputBox(inputbox_startX, inputbox_startY, inputbox_width, inputbox_text);
    cursorX := inputbox_startX + Length(inputbox_text);
    cursorY := inputbox_startY;
    textFileName := '';
    cursoron;
    repeat
        c := ReadKey;
        if c = #0 then c := ReadKey
        else if (c in valid_file_name_char) and (Length(textFileName) < inputbox_width) then
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

    if textFileName = '' then textFileName := 'Passages/test.txt';
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

        state := 1; //advance to mainScreen
    end
    else
    begin
        drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, textFileName + ' not found.', False, 'a');
        state := -1; //exit
        ReadLn;
    end;
end;

procedure mainScreen(var state : Integer);
(*Stats, Find, settings, exit*)
//Todo relocate these buttons
const title_art_path = 'Text files/title.txt';
      instruction_label_text = 'Use arrow keys to navigate. Press Enter to confirm.';
      button_function_button_width = 15;
      button_function_button_height = 5;
      button_stats_startX = 34;
      button_stats_startY = 16;
      button_find_startX = button_stats_startX + button_function_button_width + 20;
      button_find_startY = button_stats_startY;
      button_secondary_button_width = 14;
      button_secondary_button_height = 3;
      button_settings_startX = button_stats_startX+(button_function_button_width - button_secondary_button_width);
      button_settings_startY = button_stats_startY + button_function_button_height + 3;
      button_exit_startX = button_find_startX;
      button_exit_startY = button_settings_startY;
var c : char;
	position : Integer;
    currentTextFileLabel : string;
begin
    ClrScr;
    cursoroff;
    drawFromTxtFile(window_width div 2 - 79 div 2, 1, title_art_path);
    currentTextFileLabel := 'Current text file: ' + textFileName;
	position := 1; //selected the first button
    drawButton(button_stats_startX, button_stats_startY, button_function_button_width, button_function_button_height, 'Stats', True);
	drawButton(button_find_startX, button_find_startY, button_function_button_width, button_function_button_height, 'Find', False);
	drawButton(button_settings_startX, button_settings_startY, button_secondary_button_width, button_secondary_button_height, 'Settings', False);
    drawButton(button_exit_startX, button_exit_startY, button_secondary_button_width, button_secondary_button_height, 'Exit', False);
    drawTextLabel(window_width div 2 - Length(currentTextFileLabel) div 2, 11, currentTextFileLabel);
    drawTextLabel(window_width div 2 - Length(instruction_label_text) div 2, 29, instruction_label_text);

    repeat
	  	c := ReadKey;
		if c = #0 then
		begin
			c := ReadKey;
			if (c = #77) or (c = #75) or (c = #72) or (c = #80) then
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
                    #72 : if position = 1 then position := 4 else position := position mod 3 + 1;
                    #80 : if position = 4 then position := 1 else position := position mod 3 + 2;
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
    state := position + 1;
end;

procedure statsScreen(var state : Integer);
(*show some basic statistics of the passage*)
const title_path = 'Text files/stats_title.txt';
      margin = 1;
      tab_width = 21;
      tab_height = 3;
      tab_startX = 85 + 8;
      tab_startY = 7;
      msgbox_width = tab_width;
      msgbox_height = 12;
      msgbox_startX = tab_startX;
      msgbox_startY = 6 + tab_height + 3;
      label_startX = tab_startX-22;
      label_startY = 4;
var position : Integer;
    c : Char;
begin
    ClrScr;
    drawFromTxtFile(1, 1, title_path);
    setScreenWidth(85);
    writeLongString(7, passage);

    position := 1;
    drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of char');
    drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfCharString, False, 'a');
    drawTextLabel(label_startX, label_startY, 'Left and right keys to view stats. Esc to exit.');

    repeat
	  	c := ReadKey;
		if c = #0 then
		begin
			c := ReadKey;
			if (c = #75) or (c = #77) then
			begin
				case c of
					#75 : if position = 1 then position := 7 else position := position - 1;
					#77 : if position = 7 then position := 1 else position := position + 1;
				end;
				case position of
					1 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of char');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfCharString, False, 'a');
                        end;
                    2 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of para');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfParaString, False, 'a');
                        end;
                    3 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of sent');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfSentString, False, 'a');
                        end;
                    4 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of words');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfWordsString, False, 'a');
                        end;
                    5 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'Reading time');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, readingTimeString, False, 'a');
                        end;
                    6 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'Reading score');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, readingEaseScoreString, False,'a');
                        end;
                    7 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of unique words');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfUniqueWordsString, False, 'a');
                        end;
				end;
			end;
		end;
	until c = #27;
    state := 1;
end;

procedure findScreen(var state : Integer);
(*
 * Find and highlight a specific word
 * TODO: rewrite it to search not just only a word, maybe a phrase
 *)
const title_path = 'Text files/find_title.txt';
      inputbox_startX = 85 + 5;
      inputbox_startY = 7;
      inputbox_width = 20;
      inputbox_description = 'Target: ';
      valid_search_target = ['a'..'z', 'A'..'Z'];
      msgbox_width = Length(inputbox_description) + inputbox_width;
      msgbox_height = 15;
      msgbox_startX = inputbox_startX;
      msgbox_startY = inputbox_startY + 3 + 1;
      label_startX = inputbox_startX-17;
      label_startY = 3;
      label_text = 'Only whole word can be searched. Esc to exit.';
var target, occurrenceString : string;
    cursorX, cursorY, occurrence : Integer;
    c : Char;
begin
    ClrScr;
    drawFromTxtFile(1, 1, title_path);
    setScreenWidth(85);
    drawTextLabel(label_startX, label_startY, label_text);
    repeat
        writeLongString(7, passage);
        drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, 'Type a word to search.', False, 'a');
        drawInputBox(inputbox_startX, inputbox_startY, inputbox_width, inputbox_description);
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
            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, occurrenceString + ' occurrence(s)', False, 'a');
            c := ReadKey;
            if c = #0 then c := ReadKey;
        end;
    until c = #27;
    state := 1;
end;

procedure settingsScreen(var state : Integer);
(*allow user to re-input the name of the file without restarting the application*)
const title_path = 'Text files/settings_title.txt';
      button_reset_startX = 5;
      button_reset_startY = 10 + 3;
      button_reset_width = 20;
      button_reset_height = 5;
      button_reset_text = 'Reset text file';
var c : Char;
begin
    ClrScr;
    drawFromTxtFile(1, 1, title_path);
    drawButton(button_reset_startX, button_reset_startY, button_reset_width, button_reset_height, button_reset_text, False);
    repeat
        c := ReadKey;
    until (c = #13) or (c = #27);
    if c = #13 then
    begin
        drawButton(button_reset_startX, button_reset_startY, button_reset_width, button_reset_height, button_reset_text, False);
        Delay(50);
        drawButton(button_reset_startX, button_reset_startY, button_reset_width, button_reset_height, button_reset_text, True);
        Delay(50);
        drawButton(button_reset_startX, button_reset_startY, button_reset_width, button_reset_height, button_reset_text, False);
        Delay(30);
        state := 0;
    end
    else state := 1;
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