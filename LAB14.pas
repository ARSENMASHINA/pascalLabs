program lab14;
uses crt;
const
  alphabet: string[16] = '0123456789ABCDEF'; 
var
  sourceStringLength: real;
  totalTranslatedNumber,InitialNumber,
	stringOfTheIntegerPart,fractionalPartOfTheString, 
	initiallyPresetNumber,originalNumber: string;
  accuracy,finalScaleOfNotation,
	originalScaleOfNotation,
	l,t2,strToIntError: integer;
	
{Процедура для разделения целой части от дробной}	
procedure separationOfFractionalAndIntegerParts(var sourceString: string);
	begin
		stringOfTheIntegerPart:=copy(sourceString,1,pos('.',sourceString)-1);
		delete(sourceString, 1,pos('.',sourceString)); 
		fractionalPartOfTheString := sourceString; 
	end;
 
{функция для перевода (целой части числа) из любой СС в 10-ю}
function translationOfTheWholePartToDec(sourceStringOfTheIntegerPart: string; finalScaleOfNotation: byte): integer;
	var
		i, sourceStringLength, sum: integer;
	begin
		sum := 0;
		sourceStringLength := length(sourceStringOfTheIntegerPart); 
		for i := 1 to sourceStringLength do
		begin
			dec(sourceStringLength); 
			sum := sum + round((pos(sourceStringOfTheIntegerPart[i], alphabet) - 1) * exp(ln(finalScaleOfNotation) * sourceStringLength));
		end;
		translationOfTheWholePartToDec := sum;
	end;
 
{функция для перевода целой части числа из 10-й в любую сс}
function translationOfTheWholeDecPartToAny(sourceStringLength: real; PresetNumberSystem: integer): string;
	var
		InitialNumber: string;
		integerPartOfTheNumber: integer;
	begin
		integerPartOfTheNumber := round(int(sourceStringLength)); 
		InitialNumber := '';
		repeat
			InitialNumber := ((alphabet[integerPartOfTheNumber mod PresetNumberSystem + 1]) + InitialNumber);
			integerPartOfTheNumber := integerPartOfTheNumber div PresetNumberSystem;
		until (integerPartOfTheNumber = 0);
		translationOfTheWholeDecPartToAny := InitialNumber;
	end;
 
{функция для перевода дробной части числа из 10-й в любую сс}
function fractionalPartOfTheWholeDecPartToAny (sourceStringLength: real; accuracy, PresetNumberSystem: integer): string;
	var
		InitialNumber: string;
		l2,k: real;
		i: integer;
	begin
		k := sourceStringLength - int(sourceStringLength);
		InitialNumber := '';
		i := 0;
		if accuracy <> 0 then 
		begin
			repeat
				l2 := k * PresetNumberSystem;
				k := frac(l2); 
				InitialNumber := InitialNumber + alphabet[round(int(l2)) + 1];
				inc(i); 
			until i = accuracy;
		end
		else  
		 InitialNumber := '0'; 
		fractionalPartOfTheWholeDecPartToAny := InitialNumber;
	end;
 
{функция для проверки может ли быть это число в заданной системе счисления}
Function isNumberSystemCorrect(PresetNumberSystem:integer;InitialNumber:string):boolean;
	Var
	 i,numberOfCharacters,j:integer;
	begin
	numberOfCharacters:=0;
	for i:=1 to PresetNumberSystem do 
	begin
	 for j:=1 to length(InitialNumber) do 
	 if InitialNumber[j]=alphabet[i] then 
		inc(numberOfCharacters);
	end;
	if numberOfCharacters=length(InitialNumber) then 
	 isNumberSystemCorrect:=true
	else  
	 isNumberSystemCorrect:=false; 
	end;
 
{Функция перевода дробной части из произвольной сс  в 10-ю}
function translationOfTheFractionalPartToDec (sourceString: string; PresetNumberSystem: integer): real;
	var
		i: integer;
		sum: real;
	begin
		for i := 1 to length(sourceString) do 
			sum := sum + (pos(sourceString[i], alphabet) - 1) * exp(ln(PresetNumberSystem) * -i);
		translationOfTheFractionalPartToDec := sum;
	end;

 
{Процедура ввода данных} 
procedure enteringValues;
	var
	choiceToAdjustOrNot: char;
	isChangesMade:boolean;
	begin
		isChangesMade:=false;
		readln(originalNumber);
		clrscr;
		Writeln('Вы ввели: ',originalNumber);
		Writeln('Хотите ли вы изменить введенное значение? Y/N');
		Writeln;
		textcolor(DarkGray);
		Writeln('Убедитесь в том, что включена английская раскладка клавиатуры');
		textcolor(LightGray);
		repeat
			choiceToAdjustOrNot:=readkey;
			if (choiceToAdjustOrNot=#89) or 
				 (choiceToAdjustOrNot=#78) or 
				 (choiceToAdjustOrNot=#121) or 
				 (choiceToAdjustOrNot=#110) then
				begin
					if (choiceToAdjustOrNot=#89) or (choiceToAdjustOrNot=#121) then
						begin
							repeat
								Writeln('Прошлое значение: ',
									originalNumber);
								Write('Введите новое значение: ');
								readln(originalNumber);
								Writeln;
								Writeln('Новое значение: ',originalNumber);
								textcolor(DarkGray);
								Writeln('Для завершения редактирования нажмите "Esc"');
								Writeln('Для повторного ввода нажмите любую клавишу отличную от "Esc"');
								textcolor(LightGray);
								choiceToAdjustOrNot:=readkey;
							until choiceToAdjustOrNot=#27;	
							isChangesMade:=true;
							clrscr;
						end;
					if (choiceToAdjustOrNot=#78) or (choiceToAdjustOrNot=#110) then 
						begin
							clrscr;
							isChangesMade:=true;
						end;
				end
		until isChangesMade=true;
	end;
 
{Процедура для вывода сообщения об ошибке}  
procedure errorMessage;
	begin
		textcolor(red);
		writeln('Не удовлетворяет условию');
		textcolor(DarkGray);
		WriteLn;	
		writeln('Для повтора ввода нажмите любую клавишу');
		textcolor(LightGray);
		readkey;
		clrscr;
	end;
 
begin
  ClrScr;
  accuracy:=10;
  originalScaleOfNotation:=0;
  finalScaleOfNotation:=0;
  repeat
    write('Из какой будем переводить сс: ');
		enteringValues;
		VAL (originalNumber, originalScaleOfNotation, strToIntError);
		if (originalScaleOfNotation in [0..1] ) or (originalScaleOfNotation>16) then 
		  begin
				errorMessage;
		  end
		else 
			repeat 
				begin 
					write('Введите СС в которую хотите перевести: ');
					enteringValues;
					VAL (originalNumber, finalScaleOfNotation, strToIntError);
					if (finalScaleOfNotation > 16) then 
						begin
							errorMessage;
						end;
				end; 
			until finalScaleOfNotation in [2..16];
  until originalScaleOfNotation in [2..16]; 
  repeat
   write('Ввод числа в ', originalScaleOfNotation, '-й СС: ');
   enteringValues;
   InitialNumber:=originalNumber;
   initiallyPresetNumber:=InitialNumber;
   if pos(',',InitialNumber)<>0 then 
		begin
			InitialNumber[pos(',',InitialNumber)]:='.'; 
		end;
   t2:=pos('.',InitialNumber);
   val(InitialNumber,sourceStringLength,l);
   separationOfFractionalAndIntegerParts(InitialNumber);
   if (isNumberSystemCorrect(originalScaleOfNotation,stringOfTheIntegerPart)=false) or (isNumberSystemCorrect(originalScaleOfNotation,fractionalPartOfTheString)=false) then 
		begin
			textcolor(red);
			write('Некорректное число. ');
			textcolor(LightGray);
			write('Повторите ');
		end; 
  until (isNumberSystemCorrect(originalScaleOfNotation,stringOfTheIntegerPart)=true) and (isNumberSystemCorrect(originalScaleOfNotation,fractionalPartOfTheString)=true); 
  if originalScaleOfNotation = 10 then 
		begin
			if ((sourceStringLength - round(int(sourceStringLength))) = 0) then 
				totalTranslatedNumber := translationOfTheWholeDecPartToAny(sourceStringLength, finalScaleOfNotation)
			else    
				totalTranslatedNumber := translationOfTheWholeDecPartToAny(sourceStringLength, finalScaleOfNotation) + 
																',' + 
																fractionalPartOfTheWholeDecPartToAny(sourceStringLength, accuracy, finalScaleOfNotation);
		end
  else 
		begin
			if t2=0 then 
				totalTranslatedNumber := translationOfTheWholeDecPartToAny(translationOfTheWholePartToDec(fractionalPartOfTheString, originalScaleOfNotation), finalScaleOfNotation)

			else
				totalTranslatedNumber := translationOfTheWholeDecPartToAny(translationOfTheWholePartToDec(stringOfTheIntegerPart, originalScaleOfNotation), finalScaleOfNotation) + 
																 ',' + 
																 fractionalPartOfTheWholeDecPartToAny(translationOfTheFractionalPartToDec(fractionalPartOfTheString, originalScaleOfNotation),accuracy, finalScaleOfNotation);
		end;
  textcolor(Green);
  writeln('Успешно:');
  textcolor(LightGray);
  writeln('Число ',
        initiallyPresetNumber,
        ' из ',
				originalScaleOfNotation,
        '-ой системы счисления',
        ' в ',
				finalScaleOfNotation,
        '-ой системе счисления = ',
        totalTranslatedNumber);
	WriteLn;			
	textcolor(DarkGray);
	WriteLn('Нажмите любую клавишу для выхода');
	textcolor(LightGray);
  readkey;
end.