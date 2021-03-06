program main;
{*
 * Screen id (not finalized):
 * -1: exit application
 * 0 : main screen
 * 1 : (exit application...)
 * 2 : preference screen
 * ...
 *}
uses crt, ui, FastConsole, longStringType, stringListType;
const title_art_path = 'Text files/title.txt';
	  window_width = 120;
	  file_path = 'Text files/passage.txt';
	  eos_marks = ['.', '?', '!'];

var screenWidth : Integer;
	screenId : Integer;

procedure mainScreen(var nextscreen: Integer);
//todo declare const inside procedure
var c : char;
	position : Integer;
begin
	ClrScr;
    drawFromTxtFile(4, 4, title_art_path);
	drawButton(3, 15, 15, 5, 'kaito00', True);
	position := 1; //selected the first button
	drawButton(30, 15, 15, 5, 'kaito01', False);
	drawButton(57, 15, 15, 5, 'kaito02', False);

	repeat
	  	c := ReadKey;
		if c = #0 then
		begin
			c := ReadKey;
			if (c = #77) or (c = #75) then
			begin
				case position of
					1 : drawButton(3, 15, 15, 5, 'kaito00', False);
					2 : drawButton(30, 15, 15, 5, 'kaito01', False);
					3 : drawButton(57, 15, 15, 5, 'kaito02', False);
				end;
				case c of
					#77 : if position = 3 then position := 1 else position := position + 1;
					#75 : if position = 1 then position := 3 else position := position - 1;
				end;
				case position of
					1 : drawButton(3, 15, 15, 5, 'kaito00', True);
					2 : drawButton(30, 15, 15, 5, 'kaito01', True);
					3 : drawButton(57, 15, 15, 5, 'kaito02', True);
				end;
			end;

		end;
	until c = #13;
	nextscreen := position;
end;


procedure preferenceScreen(var nextscreen : Integer);
var c : char;
	position, i : Integer;
	preference : array[0..2] of Boolean;
begin
	ClrScr;
	for i := 0 to 2 do
		preference[i] := False;
	drawCheckBox(5, 2, 'I''m a nerd.', true, False);
	position := 0;
	drawCheckBox(5, 4, 'I''m definitely a nerd.', False, False);
	drawCheckBox(5, 6, 'I''m absolutely a nerd.', False, False);
	GotoXY(23, 8);
	Write('- Herny YSL');
	repeat
	  	c := ReadKey;
		if (c = #0) or (c = #13) then
		begin
			if (c = #0) then c := ReadKey;
			if (c = #72) or (c = #80) or (c = #13) then
			begin
				case position of
					0 : drawCheckBox(5, 2, 'I''m a nerd.', False, preference[position]);
					1 : drawCheckBox(5, 4, 'I''m definitely a nerd.', False, preference[position]);
					2 : drawCheckBox(5, 6, 'I''m absolutely a nerd.', False, preference[position]);
				end;
				case c of
					#72 : if position = 0 then position := 2 else position := position - 1;
					#80 : if position = 2 then position := 0 else position := position + 1;
					#13 : if preference[position] then preference[position] := False else preference[position] := True;
				end;
				case position of
					0 : drawCheckBox(5, 2, 'I''m a nerd.', True, preference[position]);
					1 : drawCheckBox(5, 4, 'I''m definitely a nerd.', True, preference[position]);
					2 : drawCheckBox(5, 6, 'I''m absolutely a nerd.', True, preference[position]);
				end;
			end;
		end;
	until c = #27;
	nextscreen := 0;
end;

function toMinute(r : Real): string;
var m, s : string;
begin
	Str(trunc(r), m);
	Str(frac(r)*60:0:0, s);
	toMinute := m + ':' + s;
end;

function countNoOfSentences(s : longString): Integer;
//TODO !!!boss!!!
var i : Integer;
begin
	countNoOfSentences := 0;
	for i := 0 to Length(s)-1 do
	  	if s[i] in eos_marks then
			countNoOfSentences := countNoOfSentences + 1;
end;

function getListOfUniqueWords(s : longString): stringList;
(* Get a set of unique words from a passage
 * Current problems:
 * Only words are being considered, other words
 * such as emails (treated as one word) or short
 * forms (e.g. U.S., a.k.a.) can't be added to
 * the list correctly.
 *)
var i : Integer;
	temp : string;
begin
	clear(getListOfUniqueWords);
	temp := '';
	for i := 0 to Length(s)-1 do
	begin
		if (s[i] in ['a'..'z']) or (s[i] in ['A'..'Z']) or (s[i] in ['0'..'9']) then
            temp := temp + lowerCase(s[i])
		else
		begin
			if (not(contains(getListOfUniqueWords, temp)) or (size(getListOfUniqueWords) = 0)) and (temp <> '') then
				add(getListOfUniqueWords, temp);
			temp := '';
		end;
	end;
end;


procedure analyseScreen(var nextscreen : Integer);
var passage : longString;
    t : Text;
	words, i : Integer;
	uniqueWords : stringList;
begin
	ClrScr;
    Assign(t, file_path);
    Reset(t);
    readLongString(t, passage);
	GotoXY(1, 1);

    writeLongString(passage);

	WriteLn;
	WriteLn('==========');

	Write('No. of characters: ');
	WriteLn(Length(passage) - countInLongString(#10, passage) - countInLongString(#13, passage));

	Write('No. of paragraphs: ');
	WriteLn(countInLongString(#13 + #10, passage) + 1);

	Write('No. of sentences(not accurate): '); //Todo can't count dialogs
	WriteLn(countNoOfSentences(passage));

	Write('No. of words: ');
	words := countInLongString(' ', passage) + countInLongString(#13 + #10, passage) + 1 - countInLongString('-', passage);
	WriteLn(words);

	Write('Reading time (200 wpm/min): ');
	WriteLn(toMinute(words / 200));

	uniqueWords := getListOfUniqueWords(passage);
	Write('No. of unique words: ');
	WriteLn(size(uniqueWords));
	for i := 0 to size(uniqueWords)-1 do
		writeln(uniqueWords[i]);

	ReadLn;
	Close(t);
	nextscreen := 0;
end;

begin
	cursoroff;
	setScreenWidth(window_width); //initialization for writeLongString
	screenWidth := getWindowWidth;
	screenId := 0;
	if screenWidth <> window_width then
	begin
		GotoXY(10, 5);
		Write('For the best experience, please set the window''s width to ');
		Write(window_width);
		Write('.');
		GotoXY(10, 6);
		Write('Current window''s width is: ');
		Write(screenWidth);
		ReadLn;
		exit;
	end;
	repeat
	  	case screenId of
		    0 : mainScreen(screenId);
			2 : preferenceScreen(screenId);
			3 : analyseScreen(screenId);
		end;
	until screenId = 1;
	ClrScr;
	WriteLn(screenId);
	ReadLn;
end.
