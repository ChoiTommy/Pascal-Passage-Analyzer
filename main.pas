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

var i : Integer;

procedure checkScreenWidthScreen(var state : Integer);
(*write and check WhereX at the same time to check if the screen width is 120*)
var screenWidth : Integer;
	screenWidthString : string;
begin
    screenWidth := getWindowWidth;
	if screenWidth <> window_width then
	begin
        cursoroff;
		Str(screenWidth, screenWidthString);
		drawMsgBox(3, 3, 114, 24, 'Please set your window to 120*30. Current width: ' + screenWidthString, -1);
		state := -1; //exit
	end
    else state := 0; //advance to importTextFileScreen()
end;

procedure importTextFileScreen(var state : Integer);
(*Let user to input the file name of the passage*)
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
	textFileName : string;
begin
    ClrScr;
	drawFromTxtFile(29, 3, 'Text files/banner.txt', False, False); //TODO declare constants for positioning
    drawMsgBox(29, 12, 62, 15, '', -1);
    drawInputBox(37, 14, 30, 'File name', 'default.txt');
    drawButton(60, 25, 10, 1, 'Quit', 1);
    drawButton(74, 25, 10, 1, 'OK', 1);
    {cursorX := inputbox_startX + Length(inputbox_text);
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
    cursoroff;}

    {if textFileName = '' then textFileName := 'Passages/test.txt';
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
        drawMsgBox(msgbox_startX, msgbox_startY, msgbox_width, msgbox_height, textFileName + ' not found.', -1);
        state := -1; //exit
        ReadLn;
    end;}
end;

begin
    importTextFileScreen(i);
	ReadLn;
end.