program BASIC_STATS;
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
	  words_set = ['A'..'Z', 'a'..'z', '0'..'9'];

var textFileName : string; //user input of text file name (in .txt form)
    t : Text; //variable stores the text file
    passage : longString; //array of char that saves the whole passage
    i : Integer;
	noOfChar, noOfPara, noOfSent, noOfWords : Integer;
	readingTime : string;
	readingEaseScore : Real;
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

		noOfChar := countNoOfChar(passage);
		noOfPara := countNoOfPara(passage);
		noOfSent := countNoOfSentences(passage);
		noOfWords := countNoOfWords(passage);
		readingTime := generateReadingTime(noOfWords);
		readingEaseScore := generateReadingEaseScore(passage, noOfWords, noOfSent);

		WriteLn;
		WriteLn('==========');

		Write('No. of characters: ');
		WriteLn(noOfChar);

		Write('No. of paragraphs: ');
		WriteLn(noOfPara);

		Write('No. of sentences(not accurate): '); //Todo can't count dialogs
		WriteLn(noOfSent);

		Write('No. of words: ');
		WriteLn(noOfWords);

		Write('Reading time (200 wpm): ');
		WriteLn(readingTime);

		Write('Reading ease score: ');
		WriteLn(readingEaseScore:4:2);

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