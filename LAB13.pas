Program queue;
uses crt;

TYPE recordPointer=^store; 
	store=record
	number : integer;
	name : string[15];
	address: string[20];
	fullNameOfTheDirector: string[25];
	workingHours: record
		hoursW1:integer;
		minutesW1:integer;
		hoursW2:integer;
		minutesW2:integer 
	end;
	breakHours: record
		hoursB1:integer;
		minutesB1:integer;
		hoursB2:integer;
		minutesB2:integer
	end;
	workingOrNonWorkingHours: array[1..7] of integer;
	nextPointer:recordPointer;
	prevPointer:recordPointer;
	end;
	weekdayPair = record
			number: integer;
			name: string;
	end;
	weekdayPairsMap=array[1..7] of weekdayPair;
VAR 
	weekdayPairs:weekdayPairsMap;
	WeakendDays: array[1..7] of integer;
	Head,temp,tail,topOfTheList,
	endOfTheList:recordPointer; 
	hoursAI,minutesAI,hoursBI,minutesBI,
	strToIntError,totalNumberOfStores,day,
	storeCounterOnVacation,storeNumberF: integer;
	hoursA,minutesA,hoursB,minutesB: string;
	menuOptionSelection:char;
	tmpl:recordPointer;
	
	{Процедура выбора выходных дней}
	procedure SelectWeekends;
		var j,selectedNumberOfTheWeekday: integer;
			begin
				selectedNumberOfTheWeekday:=999;
				for j:=1 to 7 do 
					writeln(j,'. ',weekdayPairs[j].name);
					writeln('0.  Чтобы окончить ввод');
					
				for j:=1 to 7 do 
					begin 
						WeakendDays[j]:=1;
					end;
				while selectedNumberOfTheWeekday<>0 do
					begin
						writeln('Выберите соответствующую цифру');
						readln (selectedNumberOfTheWeekday);
						if selectedNumberOfTheWeekday>7 then 
							begin
								writeln('Такого дня недели нет');
							end
						else 
							begin
								if selectedNumberOfTheWeekday<>0 then WeakendDays[selectedNumberOfTheWeekday]:=0
							end;
					end;
			end;						
	
	{Процедура добавления нового элемента в двунаправленный список}
	procedure AddElem(var head,tail:recordPointer;number:integer; name,address,fullNameOfTheDirector:string; hAWorkingHours,
												minAWorkingHours,hBWorkingHours,minBWorkingHours,hABreakHours,minABreakHours,
												hBBreakHours,minBBreakHours:integer);
	var i:integer;											
	begin
		if head=nil then {не пуст ли список, если пуст, то}
		begin
			New(head); {создаём элемент, указатель head уже будет иметь адрес}
			head^.nextPointer:=nil; {никогда не забываем "занулять" указатели}
			head^.prevPointer:=nil; {аналогично}
			tail:=head; {изменяем указатель конца списка}
		end
		else {если список не пуст}
		begin
			New(tail^.nextPointer); {создаём новый элемент}
			tail^.nextPointer^.prevPointer:=tail; {связь нового элемента с последним элементом списка}
			tail:=tail^.nextPointer;{конец списка изменился и мы указатель "переставляем"}
			tail^.nextPointer:=nil; {не забываем "занулять" указатели}
		end;
		tail^.number:=number; {заносим данные}
		tail^.name:=name;
		tail^.address:=address;
		tail^.fullNameOfTheDirector:=fullNameOfTheDirector;
		tail^.workingHours.hoursW1:=hAWorkingHours;
		tail^.workingHours.minutesW1:=minAWorkingHours;
		tail^.workingHours.hoursW2:=hBWorkingHours;
		tail^.workingHours.minutesW2:=minBWorkingHours;
		tail^.breakHours.hoursB1:=hABreakHours;
		tail^.breakHours.minutesB1:=minABreakHours;
		tail^.breakHours.hoursB2:=hBBreakHours;
		tail^.breakHours.minutesB2:=minBBreakHours;
		for i:=1 to 7 do 
			begin
				tail^.workingOrNonWorkingHours[i]:=WeakendDays[i]
			end;
		totalNumberOfStores:=totalNumberOfStores+1;
	end;
	
	{Процедура вывода списка}
	procedure printTheStores(shopList:recordPointer);
	var j:integer;
	begin
		clrscr;
		if shopList=nil then
		begin
			writeln('Список пуст.');
			exit;
		end;
		while shopList<>nil do
		begin
			Writeln;
			Writeln('Номер магазина: ',shopList^.number, ' ');
			Writeln('Название магазина: ',shopList^.name, ' ');
			Writeln('Адрес магазина: ',shopList^.address, ' ');
			Writeln('ФИО директора: ',shopList^.fullNameOfTheDirector, ' ');
			writeln('Часы работы магазина: C - ',
				shopList^.workingHours.hoursW1,
				' : ',
				shopList^.workingHours.minutesW1,
				'  До - ',
				shopList^.workingHours.hoursW2,
				' : ',
				shopList^.workingHours.minutesW2);
			writeln('Перерыв: C ',
				shopList^.breakHours.hoursB1,
				' : ',
				shopList^.breakHours.minutesB1,
				' До - ',
				shopList^.breakHours.hoursB2,
				' : ',
				shopList^.breakHours.minutesB2);
			for j:=1 to 7 do 
				begin 
					if shopList^.workingOrNonWorkingHours[j]=0 then 
						begin
							writeln(weekdayPairs[j].name:11, ' - выходной');	
						end;
					if shopList^.workingOrNonWorkingHours[j]=1 then 
						begin
							writeln(weekdayPairs[j].name:11, ' - рабочий день');
						end;
				end;
			shopList:=shopList^.nextPointer
			end;
		readkey;
	end;
	
	{Процедура ввода времени}
	procedure EnterTime;
		var positionLastColon,positionHyphen,positionFirstColon,hyphenCounter,colonCounter,colonCounterFromTheMiddle:integer;
		TimeString: string;
		x:integer;
		colonCounterFlag,isTimeInputCorrect:boolean;
			begin
				repeat
					readln(TimeString);
					positionHyphen:=0;
					positionFirstColon:=0;
					positionLastColon:=0;
					hoursA:='';
					minutesA:='';
					hoursB:='';
					minutesB:='';
					colonCounterFlag:=true;
					isTimeInputCorrect:=true;
					hyphenCounter:=0;
					colonCounter:=0;
					colonCounterFromTheMiddle:=0;
					for x := 1 to length(TimeString) do
						begin
							if TimeString[x] = ':' then 
								begin
									positionLastColon := x;
									colonCounter:=colonCounter+1;
								end;
						end;
					for x :=1 to length(TimeString) do
						if TimeString[x] = '-' then 
							begin
								positionHyphen := x;
								hyphenCounter:=hyphenCounter+1;
							end;
					for x := 1 to positionHyphen-1 do
						if TimeString[x] = ':' then 
							begin
								positionFirstColon := x;
							end;

					for x := 1 to positionHyphen-1 do
						begin
							if TimeString[x] = ':' then 
								begin
									colonCounterFromTheMiddle:=colonCounterFromTheMiddle+1;
									if colonCounterFromTheMiddle=2 then colonCounterFlag:=false;
								end;
						end;
					colonCounterFromTheMiddle:=0;
					for x := positionHyphen+1 to length(TimeString) do
						begin
							if TimeString[x] = ':' then 
								begin
									colonCounterFromTheMiddle:=colonCounterFromTheMiddle+1;
									if colonCounterFromTheMiddle=2 then colonCounterFlag:=false;
								end;
						end;

					if (colonCounter<>2) or (hyphenCounter<>1) or (colonCounterFlag = false) then 
					begin
					writeln('Неверно введено. Повоторите ввод по по формату HH:MM-HH:MM');
					end
					else
						begin
							for x := 1 to positionFirstColon-1 do hoursA := hoursA + TimeString[x];
							for x := positionFirstColon+1 to positionHyphen-1 do minutesA:= minutesA + TimeString[x];
							for x := positionHyphen+1 to positionLastColon-1 do hoursB:= hoursB + TimeString[x];
							for x := positionLastColon+1 to length(TimeString) do minutesB:= minutesB + TimeString[x];
							
							VAL (hoursA, hoursAI, strToIntError);
							VAL (minutesA, minutesAI, strToIntError);
							VAL (hoursB, hoursBI, strToIntError);
							VAL (minutesB, minutesBI, strToIntError);
							if (hoursAI >= 24) or (hoursBI >= 24) then 
									begin
										isTimeInputCorrect:=false;
										writeln('Неверно введено. Часов не может быть больше 23. ');
										write('Повоторите ввод по по формату HH:MM-HH:MM ');
									end;
							if ((minutesAI >= 60) or (minutesBI >= 60)) then 
								begin 
									if isTimeInputCorrect=false then 
										 begin
											writeln(' при этом минут не может быть больше 59. ');
										 end
									else 
										begin
											isTimeInputCorrect:=false;
											writeln('Неверно введено. Минут не может быть больше 59. ');
											writeln('Повоторите ввод по по формату HH:MM-HH:MM ');
										end;
								end;
							if ((hoursAI<0) or (minutesAI<0) or (hoursBI<0) or (minutesBI<0))  then
								begin 
									if isTimeInputCorrect=false then 
										 begin
											writeln('при этом Вы ввели отрицательное значение. ');
										 end
								 else 
										begin
												isTimeInputCorrect:=false;
												writeln('Неверно введено. Вы ввели отрицательное значение. ');
												writeln('Повоторите ввод по по формату HH:MM-HH:MM ');
										end;
								end;
							if ((hoursAI>hoursBI) or ((hoursAI=hoursBI) and (minutesAI>minutesBI)))  then
								begin 
										if isTimeInputCorrect=false then 
											 begin
												writeln('при этом данный промежуток времени не возможен в один день. ');
											 end
									 else 
											begin
													isTimeInputCorrect:=false;
													writeln('Неверно введено. Данный промежуток времени не возможен в один день. ');
													writeln('Повоторите ввод по по формату HH:MM-HH:MM ');
											end;
								end;
							
							
						end;
				until (((colonCounter=2) and (hyphenCounter=1)) and (colonCounterFlag = true) and (isTimeInputCorrect = true));

			end;
	{Функция проверки повтора номера магазина}	
	Function repeatStoreNumber(shopList:recordPointer;storeNumber:integer):recordPointer;
	var j: integer;
		begin
		    storeNumberF:=storeNumber;
				if shopList<>nil then
					while (shopList<>nil) do
						begin
							if (shopList^.number=storeNumberF) then 
								begin 
									writeln('Такой номер уже есть. Введите другой');
					       	readln(storeNumberF);
					       	repeatStoreNumber(topOfTheList,storeNumberF);
								end
								else
									begin
										shopList:=shopList^.nextPointer;
										repeatStoreNumber:=shopList;
									end;
						end;
		end;
	
	{Процедура ввода информации об одном магазине (включает в себя: EnterTime, AddElem, SelectWeekends)}
	procedure enteringAStore;
	var
		storeNumber,hoursAWorkingHours,minutesAWorkingHours,
		hoursBWorkingHours,minutesBWorkingHours,
		hoursABreakHours,minutesABreakHours,
		hoursBBreakHours,minutesBBreakHours :integer;
		fullNameOfTheDirectorOfTheStore,storeName,storeAddress,menuOfEnteringAStore: string;
			begin
				repeat
					clrscr;
					writeln;
					write('Номер магазина: '); readln(storeNumber);
					repeatStoreNumber(topOfTheList,storeNumber);
					storeNumber:=storeNumberF;
					write('Название магазина: '); readln(storeName);
					write('Адрес магазина: '); readln(storeAddress);
					write('ФИО директора: '); readln(fullNameOfTheDirectorOfTheStore);
					write('Часы работы магазина(введите время по формату HH:MM-HH:MM)  ');
					EnterTime;
					hoursAWorkingHours:=hoursAI;
					minutesAWorkingHours:=minutesAI;
					hoursBWorkingHours:=hoursBI;
					minutesBWorkingHours:=minutesBI;
					writeln ('Вы ввели, что рабочие часы магазина: C ',
						hoursAWorkingHours,
						' : ',
						minutesAWorkingHours,
						'  До - ',
						hoursBWorkingHours,
						' : ',
						minutesBWorkingHours);
					write('Время для перерыва (вводите время по формату HH:MM-HH:MM) ');
					EnterTime;
					hoursABreakHours:=hoursAI;
					minutesABreakHours:=minutesAI;
					hoursBBreakHours:=hoursBI;
					minutesBBreakHours:=minutesBI;
					writeln('Перерыв: C ',
						hoursABreakHours,
						' : ',
						minutesABreakHours,
						' До -  ',
						hoursBBreakHours,
						' : ',
						minutesBBreakHours);
						writeln;
						writeln('Выходные дни:');
						SelectWeekends;
					AddElem(topOfTheList,endOfTheList,storeNumber,
									storeName,storeAddress,fullNameOfTheDirectorOfTheStore,
									hoursAWorkingHours,minutesAWorkingHours,
									hoursBWorkingHours,minutesBWorkingHours,
									hoursABreakHours,minutesABreakHours,
									hoursBBreakHours,minutesBBreakHours);
					writeln('Введите "0" для окончания ввода.');
					writeln('Введите отличный от "0" символ для продолжения ввода.');
					readln(menuOfEnteringAStore);
				until menuOfEnteringAStore='0'
							
			end;
			
	{Функция обработки данных, вывод магазинов, работающих в указанный день}
	Function dayDataProcessing(shopList:recordPointer;dayNumberEnteredByTheUser:integer):recordPointer;
	var j: integer;
		begin
			storeCounterOnVacation:=0;
			if shopList<>nil then
				while (shopList<>nil) do
					begin
						if (shopList^.workingOrNonWorkingHours[dayNumberEnteredByTheUser]=1) then
							begin
								Writeln;
								Writeln('Номер магазина: ',shopList^.number, ' ');
								Writeln('Название магазина: ',shopList^.name, ' ');
								Writeln('Адрес магазина: ',shopList^.address, ' ');
								Writeln('ФИО директора: ',shopList^.fullNameOfTheDirector, ' ');
								writeln('Часы работы магазина: C - ',
									shopList^.workingHours.hoursW1,
									' : ',
									shopList^.workingHours.minutesW1,
									'  До - ',
									shopList^.workingHours.hoursW2,
									' : ',
									shopList^.workingHours.minutesW2);
								writeln('Перерыв: C ',
									shopList^.breakHours.hoursB1,
									' : ',
									shopList^.breakHours.minutesB1,
									' До - ',
									shopList^.breakHours.hoursB2,
									' : ',
									shopList^.breakHours.minutesB2);
								for j:=1 to 7 do 
									begin 
										if shopList^.workingOrNonWorkingHours[j]=0 then 
										begin
											writeln(weekdayPairs[j].name:11, ' - выходной');	
										end;
										if shopList^.workingOrNonWorkingHours[j]=1 then 
										begin
											writeln(weekdayPairs[j].name:11, ' - рабочий день');
										end;
									end;
								shopList:=shopList^.nextPointer;
								dayDataProcessing:=shopList;				
							end
							else
								begin
									storeCounterOnVacation:=storeCounterOnVacation+1;
									shopList:=shopList^.nextPointer;
									dayDataProcessing:=shopList;
								end;
							
					end;
		end;				
	
	{Процедура для вывода магазинов, работающих в указанный день (включает в себя: dayDataProcessing)}
	procedure PrintWorkingShops;
	var 
	i: integer;
		begin
			clrscr;
			for i:=1 to 7 do 
				begin
					writeln(i,'. ',weekdayPairs[i].name);
				end;
			write('Введите номер дня >');
			readln(day);
			writeln('День недели номер: ',day);
			tmpl:=dayDataProcessing(topOfTheList,day);
			writeln('totalNumberOfStores: ',totalNumberOfStores);
			writeln('storeCounterOnVacation: ',storeCounterOnVacation);
			if storeCounterOnVacation=totalNumberOfStores then
				begin
					write('Работающих магазинов нет.');
				end;
			readkey;	
		end;


begin
	clrscr;
	totalNumberOfStores:=0;
	{------------------}
	{weekday Pairs Map:}
	weekdayPairs[1].number:=1;
	weekdayPairs[1].name:='Понедельник';
	weekdayPairs[2].number:=2;
	weekdayPairs[2].name:='Вторник';
	weekdayPairs[3].number:=3;
	weekdayPairs[3].name:='Среда';
	weekdayPairs[4].number:=4;
	weekdayPairs[4].name:='Четверг';
	weekdayPairs[5].number:=5;
	weekdayPairs[5].name:='Пятница';
	weekdayPairs[6].number:=6;
	weekdayPairs[6].name:='Суббота';
	weekdayPairs[7].number:=7;
	weekdayPairs[7].name:='Воскресение';
	{end of weekday Pairs Map}
	{------------------}
  topOfTheList:=nil;
  endOfTheList:=nil;
	repeat
		clrscr;
		Writeln('1) Добавить магазин.');
    Writeln('2) Вывод списка магазинов.');
		Writeln('3) Обработка данных.');
    Writeln('9) Выход.');
		menuOptionSelection:=readkey;
			case menuOptionSelection of
			
				'1':begin
							enteringAStore;
						end;
						
				'2':begin
							printTheStores(topOfTheList);
						end;
						
				'3':begin
							PrintWorkingShops;
						end;
			end;
  until menuOptionSelection='9';	
end.