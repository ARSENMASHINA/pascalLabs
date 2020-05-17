program lab15;
Uses Graph,crt;
const ballRadius=20;
			g=9.8;
Var
  x,y,graphDriver,graphMode,Vy,Vx: Integer;
	coefficientOfFriction,ballMass,frictionForce,
	resultForce,VxReal,VyReal: real;
	exitCondition: char;

procedure checkBorders(var x,y: integer);
	begin
		if 10+ballRadius>=X then
			begin
				Vx:=-Vx;
				X:=10+ballRadius;
			end;
		if 590-ballRadius<=X then
			begin
				Vx:=-Vx;
				X:=590-ballRadius;
			end;
		if 10+ballRadius>=Y then
			begin
				Vy:=-Vy;
				y:=10+ballRadius;
			end;
		if 390-ballRadius<=Y then
			begin
				Vy:=-Vy;
				y:=390-ballRadius;
			end;
	end;
	
procedure drawABall(var x,y: integer);
	begin
		x:=x+Vx;
		y:=y+Vy;
		checkBorders(x,y);
		setcolor(15);
		setfillstyle(1,15);
		fillellipse(x,y,ballRadius,ballRadius);
		delay(50);
		setcolor(2);
		setfillstyle(1,2);
		fillellipse(x,y,ballRadius,ballRadius);
	end;	

procedure ballSpeedCalculation;
	begin
		frictionForce:=((coefficientOfFriction*ballMass*g)/(ballRadius));
		resultForce:=sqrt((Vy*Vy)+(Vx*Vx));
		resultForce:=resultForce-frictionForce;
		if resultForce<=0 then
			begin
				Vx:=0;
				Vy:=0;
			end
		else
			begin
				VyReal:=(resultForce*Vy)/(sqrt((Vy*Vy)+(Vx*Vx)));
				VxReal:=(resultForce*Vx)/(sqrt((Vy*Vy)+(Vx*Vx)));
				Vx:=round(VxReal);
				Vy:=round(VyReal);
			end;
	end;

procedure enterData;
	begin
	writeln ('Enter:');
		write ('The initial coordinate of the ball along the X axis');
		textcolor(DarkGray);
		write(' (expected range from 30 to 570)');
		textcolor(LightGray);
		write(' = ');
		read(x);
		if (x<10+ballRadius) or (590-ballRadius<x) then
			begin
				repeat
				write('Repeat the initial coordinate of the ball along the X axis = ');
				readln(x);
				until (x>=10+ballRadius) and (590-ballRadius>=x);
			end;
		write ('The initial coordinate of the ball along the Y axis');
		textcolor(DarkGray);
		write(' (expected range from 30 to 370)');
		textcolor(LightGray);
		write(' = ');
		readln(y);
		if (y<10+ballRadius) or (390-ballRadius<y) then
			begin
				repeat
				write('Repeat the initial coordinate of the ball along the Y axis = ');
				readln(y);
				until (y>=10+ballRadius) and (390-ballRadius>=y);
			end;
		write ('X axis initial velocity = ');
		readln(Vx);
		write ('Y ball initial velocity = ');
		readln(Vy);	
		write('Coefficient of friction');
		textcolor(DarkGray);
		write(' (Multiply tabular values by 100)');
		textcolor(LightGray);
		write(' = ');
		readln(coefficientOfFriction);
		write ('Mass of ball = ');
		readln(ballMass);
	end;
	
procedure drawingABallAfterCalculation;
	begin
		repeat
			ballSpeedCalculation;
			drawABall(x,y);
		until (Vx=0) and (Vx=0);
	setcolor(15);
	setfillstyle(1,15);
	fillellipse(x,y,ballRadius,ballRadius);
	setcolor(0);
	OutTextXY(470, 356, 'End of drawing');
	OutTextXY(470, 370, 'Press any key');
	setcolor(15);
	readkey;
	end;
	
	
BEGIN
  repeat
		clrscr;
		enterData;
		readkey;	
		graphDriver:=Detect;
		InitGraph(graphDriver,graphMode,'D:\BGI');
		{Draw a table}
		SetFillStyle(1, 6);	
		Bar(0,0,600,400);
		SetFillStyle(1, 2);	
		Bar(10,10,590,390);
		{---------------}
		drawingABallAfterCalculation;
		CloseGraph;
		clrscr;
		Writeln('-------------------------------------------');
		Writeln;
		Writeln('To exit, press "Esc"');
                Writeln('To restart, press any key other than "Esc"');
		Writeln;
		Writeln('-------------------------------------------');
		exitCondition:=readkey;
		
	until exitCondition=#27
	
END.
