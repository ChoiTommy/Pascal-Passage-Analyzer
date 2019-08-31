program passage_analyser;
(*
 * -1 : exit
 * 0 : file name input screen
 * 1 : main screen
 * 2 : stats for nerds
 * 3 : find
 * 4 : settings
 * 5 : exitMsgBox
 *)
uses crt, ui, FastConsole, stringListType, sysutils, longStringType;

const window_width = 120;
      window_height = 30;
      eos_marks = ['.', '?', '!']; //punctuations that indicates the end of a sentence
	  words_set = ['A'..'Z', 'a'..'z', '0'..'9'];

var state : Integer;
    passage : longString;
    textFileName : string;
    noOfSent, noOfWords : Integer;
    noOfCharString, noOfParaString, noOfSentString, noOfWordsString, readingTimeString, readingEaseScoreString : string;

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
      valid_file_name_char = ['0'..'9', 'a'..'z', 'A'..'Z', '.', ' ', '/'];
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
        c := ReadKey; //TODO dk why it can read direction keys
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
      instruction_label_text = 'Use left and right keys to navigate. Press Enter to confirm.';
      //Todo relocate these buttons
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
    state := position + 1;
end;

function toMinute(r : Real): string;
(*Convert a real number to minutes (1.0 means 1 minute)*)
var m, s : string;
begin
	Str(trunc(r), m);
	Str(frac(r)*60:0:0, s);
	toMinute := m + ':' + s;
end;

function countNoOfChar(s : longString): Integer;
begin
	countNoOfChar := Length(s) - countInLongString(#10, s) - countInLongString(#13, s);
end;

function countNoOfPara(s : longString): Integer;
begin
	countNoOfPara := countInLongString(#13 + #10, s) + 1;
end;

function countNoOfSentences(s : longString): Integer;
(*
 * Current problems:
 * The definition of a sentence is not correct.
 * Not all . means the end of a sentence (e.g
 * U.S., no., a.m.).
 * TODO:
 * Rewrite it.
 *)
var i : Integer;
begin
	countNoOfSentences := 0;
	for i := 0 to Length(s)-1 do
	  	if (s[i] in eos_marks) and ((i = Length(s) - 1) or not(s[i+1] in words_set)) then
			countNoOfSentences := countNoOfSentences + 1
end;

function countNoOfWords(s : longString): Integer;
begin
	countNoOfWords := countInLongString(' ', s) + countInLongString(#13 + #10, s) + 1 - countInLongString('-', s);
end;

function generateReadingTime(noOfWords : Integer):string;
begin
	generateReadingTime := toMinute(noOfWords / 200);
end;

function generateReadingEaseScore(s : longString; noOfWords, noOfSent : Integer):Real;
(*
 * https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests
 *)
var i : Integer;
begin
	i := countInLongString('a', s) + countInLongString('e', s) +countInLongString('i', s) + countInLongString('o', s) + countInLongString('u', s);
	generateReadingEaseScore := 206.835 - (1.015 * (noOfWords/noOfSent)) - (84.6 * (i/noOfWords));
end;

function getListOfUniqueWords(s : longString): stringList;
(* Get a set of unique words from a passage
 * Current problems:
 * Only words are being considered, other words
 * such as emails (treated as one word) or short
 * forms (e.g. U.S., a.k.a.) can't be added to
 * the list correctly. The processing time is
 * long.
 * TODO:
 * Need optimization.
 *)
var i : Integer;
	temp : string;
begin
	clear(getListOfUniqueWords);
	temp := '';
	for i := 0 to Length(s)-1 do
	begin
		if (s[i] in words_set) then
            temp := temp + lowerCase(s[i])
		else if (i <> Length(s)-1) and ((s[i] in ['.','''']) and (s[i-1] in words_set) and (s[i+1] in words_set)) then
			temp := temp + lowerCase(s[i])
		else
		begin
			if (temp <> '') and ((size(getListOfUniqueWords) = 0) or not(contains(getListOfUniqueWords, temp))) then
				add(getListOfUniqueWords, temp);
			temp := '';
		end;
	end;
end;

procedure statsScreen(var state : Integer);
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
var position : Integer;
    c : Char;
begin
    ClrScr;
    drawFromTxtFile(1, 1, title_path);
    setScreenWidth(85);
    writeLongString(margin, 7, passage);

    noOfWords := countNoOfWords(passage);
    noOfSent := countNoOfSentences(passage);
    Str(countNoOfChar(passage), noOfCharString);
    Str(countNoOfPara(passage), noOfParaString);
    Str(noOfSent, noOfSentString);
    Str(noOfWords, noOfWordsString);
    readingTimeString := generateReadingTime(noOfWords);
    Str(generateReadingEaseScore(passage, noOfWords, noOfSent):4:2, readingEaseScoreString);


    position := 1;
    drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of char');
    drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfCharString);

    repeat
	  	c := ReadKey;
		if c = #0 then
		begin
			c := ReadKey;
			if (c = #75) or (c = #77) then
			begin
				case c of
					#75 : if position = 1 then position := 6 else position := position - 1;
					#77 : if position = 6 then position := 1 else position := position + 1;
				end;
				case position of
					1 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of char');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfCharString);
                        end;
                    2 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of para');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfParaString);
                        end;
                    3 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of sent');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfParaString);
                        end;
                    4 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'No. of words');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, noOfWordsString);
                        end;
                    5 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'Reading time');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, readingTimeString);
                        end;
                    6 : begin
                            drawTab(tab_startX, tab_startY, tab_width, tab_height, 'Reading score');
                            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, readingEaseScoreString);
                        end;
				end;
			end;
		end;
	until c = #27;
    state := 1;
end;

begin
    checkScreenWidthScreen(state);
    repeat
	  	case state of
		    0 : importTextFileScreen(state);
            1 : mainScreen(state);
            2 : statsScreen(state);
		end;
	until (state = 5) or (state = -1);
    ClrScr;
    GotoXY(1, 1);
    Write('Bye!');
    //setScreenWidth(window_width);
    //writeLongString(passage);
    ReadLn;
end.