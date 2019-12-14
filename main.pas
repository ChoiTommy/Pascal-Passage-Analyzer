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

uses crt, ui, stringListType, sysutils, longStringType, passageAnalyser, FastConsole;

const window_width = 120; //console window width
      window_height = 30; //console window height

var state : Integer;
    passage : longString; //array of characters storing the passage
    noOfSent, noOfWords : Integer;
    noOfCharString, noOfParaString, noOfSentString, noOfWordsString, readingTimeString, readingEaseScoreString, noOfUniqueWordsString : string;
    uniqueWords : stringList; //array list storing unique words

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
            if (c = #77) or (c = #75) then
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
        else if (c in valid_file_name_char) and (Length(textFileName) < inputbox_boxWidth) then
        begin
            textFileName := textFileName + c;
            if (textFileName <> '') and (Length(textFileName) = 1) then
                drawInputBox(inputbox_startX, inputbox_startY, inputbox_boxWidth, inputbox_text, inputbox_hint, True);
            GotoXY(cursorX, cursorY);
            Write(c);
            cursorX := cursorX + 1;
        end
        else if (c = #8) and (Length(textFileName) > 0) then
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
    if buttonPos = 0 then state := -1
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

            state := 1; //advance to mainScreen()
        end
        else
        begin
            drawFromTxtFile(banner_startX, banner_startY, banner_path, False, False);
            drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, textFileName + ' not found. Press Enter to exit.', -1);
            state := -1; //exit
            readln;
        end;
    end;
end;

procedure mainScreen(var state : Integer);
const banner_startX = 76;
      banner_startY = 1;
      banner_path = 'Text files/mainScreenBanner.txt';
begin
    ClrScr;
    setScreenWidth(74);
    writeLongString(1, passage);
    drawFromTxtFile(banner_startX, banner_startY, banner_path, True, False);
    readln;
    state := -1;
end;

begin
    checkScreenWidthScreen(state);
    repeat
	  	case state of
		    0 : importTextFileScreen(state);
            1 : mainScreen(state);
            {2 : statsScreen(state);
            3 : findScreen(state);
            4 : settingsScreen(state);}
		end;
	until (state = 5) or (state = -1);

end.