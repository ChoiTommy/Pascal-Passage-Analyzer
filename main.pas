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

const window_width = 130; //console window width
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

begin
    checkScreenWidthScreen(i);
	ReadLn;
end.