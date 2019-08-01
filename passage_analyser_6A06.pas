program passage_analyser_6A06;
{*
 *           Pascal Passage Analyser
 * This program is created for analysing a passage
 * in a text file. Since the program is in its
 * early stage, its features are limited. It can
 * count the number of paragraphs, number of words,
 * number of sentences, reading time, number of
 * unique words in a passage.
 *}
uses longStringType, stringListType, crt, FastConsole, sysutils;

const eos_marks = ['.', '?', '!']; //punctuations that indicates the end of a sentence

var textFileName : string; //user input of text file name (in .txt form)
    t : Text; //variable stores the text file
    passage : longString; //array of char that saves the whole passage
    wordsCount, i : Integer;
    uniqueWords : stringList; //list of unique words in the passage
	fileExist : Boolean;

function toMinute(r : Real): string;
(*Convert a real number to minutes (1.0 means 1 minute)*)
var m, s : string;
begin
	Str(trunc(r), m);
	Str(frac(r)*60:0:0, s);
	toMinute := m + ':' + s;
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
	  	if s[i] in eos_marks then
			countNoOfSentences := countNoOfSentences + 1;
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

begin
    Write('Enter the name of your text file (test.txt): ');
    readln(textFileName);
    WriteLn;

	fileExist := FileExists(textFileName);

	if fileExist then
	begin
		Assign(t, textFileName);
		Reset(t);
		readLongString(t, passage);

		setScreenWidth(120);

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
		wordsCount := countInLongString(' ', passage) + countInLongString(#13 + #10, passage) + 1 - countInLongString('-', passage);
		WriteLn(wordsCount);

		Write('Reading time (200 wpm/min): ');
		WriteLn(toMinute(wordsCount / 200));

		readln;
		uniqueWords := getListOfUniqueWords(passage);
		Write('No. of unique words: ');
		WriteLn(size(uniqueWords));
		for i := 0 to size(uniqueWords)-1 do
			writeln(uniqueWords[i]);
		ReadLn;
		Close(t);
	end
	else
	begin
		WriteLn('No such file.');
		ReadLn;
	end;
end.