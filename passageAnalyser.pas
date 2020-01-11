unit passageAnalyser;

interface
uses stringListType, longStringType;
const words_set = ['A'..'Z', 'a'..'z', '0'..'9']; //characters usually in a word
function countNoOfWords(s : longString): Integer;
function countNoOfSentences(s : longString): Integer;
function countNoOfChar(s : longString): Integer;
function countNoOfPara(s : longString): Integer;
function generateReadingTime(noOfWords : Integer):string;
function generateReadingEaseScore(s : longString; noOfWords, noOfSent : Integer):Real;
procedure generateUniqueWordsTxtFile(list : stringList);
function getListOfUniqueWords(s : longString): stringList;

implementation
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
const eos_marks = ['.', '?', '!']; //punctuations that indicates the end of a sentence
var i : Integer;
begin
	countNoOfSentences := 0;
	for i := 0 to Length(s)-1 do
	  	if (s[i] in eos_marks) and ((i = Length(s) - 1) or not(s[i+1] in words_set)) then
			countNoOfSentences := countNoOfSentences + 1
end;

function countNoOfWords(s : longString): Integer;
begin
	countNoOfWords := countInLongString(' ', s) + countInLongString(#13 + #10, s) + 1;
end;

function generateReadingTime(noOfWords : Integer):string;
(*
 * Sauce: https://ezinearticles.com/?What-is-the-Average-Reading-Speed-and-the-Best-Rate-of-Reading?&id=2298503
 *)
begin
	generateReadingTime := toMinute(noOfWords / 200);
end;

function generateReadingEaseScore(s : longString; noOfWords, noOfSent : Integer):Real;
(*
 * Source: https://en.wikipedia.org/wiki/Flesch%E2%80%93Kincaid_readability_tests
 *)
var i : Integer;
begin
	i := countInLongString('a', s) + countInLongString('e', s) +countInLongString('i', s) + countInLongString('o', s) + countInLongString('u', s);
	generateReadingEaseScore := 206.835 - (1.015 * (noOfWords/noOfSent)) - (84.6 * (i/noOfWords));
end;

function getListOfUniqueWords(s : longString): stringList;
var i : Integer;
	temp : string;
begin
	clear(getListOfUniqueWords);
	temp := '';
	for i := 0 to Length(s)-1 do
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

procedure generateUniqueWordsTxtFile(list : stringList);
const unique_words_txt_file_path = 'unique_words.csv';
var t : text;
    i : Integer;
    temp : Char;
begin
    Assign(t, unique_words_txt_file_path);
    Rewrite(t);
    temp := list[0][1];
    for i := 0 to size(list)-1 do
    begin
        if temp <> list[i][1] then
        begin
            WriteLn(t);
            temp := list[i][1];
        end;
        Write(t, list[i] +',');
    end;
    Close(t);
end;

end.