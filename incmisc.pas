{spread}{A+,B-,D-,E+,F+,G+,I-,L-,N+,O+,P+,Q-,R-,S-,T-,V-,X+,Y-}
UNIT IncMisc;
INTERFACE
  uses dos;
  procedure ClearKeyBuf;
  procedure wfk;
  procedure WarmBoot;
  procedure ColdBoot;
  procedure PrintScreen;
  procedure Beep(Tone:integer;Time:word);
  Function  GetFreeConventionalMemory : LongInt;
  procedure SwapStrings(var swapping:string;stout:string;stin:string);
  procedure Ring;
  Function  BytesPerChar : Byte;
  Procedure InitVGAProgressBar(x,y:integer);
  Procedure VGAProgressBar(x,y:integer;pvalue,pofvalue:longint);
  Procedure VGAProgressBar2(x,y:integer;pvalue,pofvalue:longint);
  Function  ToUpper(S : string) : string;
  Procedure PutChar(ch:char);
  Procedure DrawCharFrame(x1,y1,x2,y2,t:integer);
  procedure quickwrite(x, y: byte; s: string; f, b: byte);
  Function  Trim(s:string):string;
  Procedure ExtendedStr(x,rmin,rmax:real;precision:integer;var s:string);
  Procedure IncPause(HS : longint);  { From: Andrew Eigus}
  FUNCTION  WildComp(wild,name:string):boolean;
  Function  Hex(Num : longint; Places : byte) : string;
  FUNCTION  PtrToLong( P:POINTER ) :LONGINT;
  Function  ByteTest(T:longint; pos:byte):boolean;
  Procedure ByteSet(Var T:longint; Pos:byte);
  Procedure ByteClear(Var T:longint; Pos:byte);
  Procedure ByteChange(Var T:longint; Pos:byte);
  function  RedirectSetOutput(FileName: PathStr): Boolean;
  procedure RedirectCancelOutput;
  Procedure RangesR(var x:real;l,h:real);
  Procedure RangesI(var x:longint;l,h:longint);
  Function  PosLast(f:string;s:string):integer;
  FUNCTION  Win3X :BOOLEAN; { Greg Estabrooks    }
  FUNCTION  WinVer :WORD;    { Greg Estabrooks    }
  Procedure CWriteln(s:string);
  Procedure RWriteln(s:string);
  Function  DosErrorText(a:integer):string;
  Function  IOErrorText(a:integer):string;
  Function  UsingInt(a:longint):string;
  Function  UsingReal(a:real):string;
  Procedure AddExt(var s:string;e:string);
  Procedure ClickAsm;
  Procedure StandardIO;
var
  Regs:Registers;
const
  MBoolYesNo:array[boolean] of string[3]=('No','Yes');
  MBoolTakNie:array[boolean] of string[3]=('Nie','Tak');
  MBoolOnOff:array[boolean] of string[3]=('Off','On');
  MBoolEnDis:array[boolean] of string[8]=('Disabled','Enabled');
  OutRedir: Boolean = False;

IMPLEMENTATION

Uses IncVideo,crt;

Procedure ClearKeyBuf;
var m:char;
begin
  while keypressed do
  m:=readkey;
end;

Procedure wfk;
begin
     repeat until keypressed;
      ClearKeyBuf;
end;

PROCEDURE WarmBoot;
BEGIN
  Inline(
        $FB/                  { STI                                  }
        $B8/00/00/            { MOV   AX,0000                        }
        $8E/$D8/              { MOV   DS,AX                          }
        $B8/$34/$12/          { MOV   AX,1234                        }
        $A3/$72/$04/          { MOV   [0472],AX                      }
        $EA/$00/$00/$FF/$FF); { JMP   FFFF:0000                      }
END;

PROCEDURE ColdBoot;
BEGIN
  Inline(
        $FB/                  { STI                                  }
        $B8/01/00/            { MOV   AX,0001                        }
        $8E/$D8/              { MOV   DS,AX                          }
        $B8/$34/$12/          { MOV   AX,1234                        }
        $A3/$72/$04/          { MOV   [0472],AX                      }
        $EA/$00/$00/$FF/$FF); { JMP   FFFF:0000                      }
END;

Procedure PrintScreen;
begin
  intr($05,Regs);
end;

procedure Beep(Tone:integer;Time:word);
begin
  sound(Tone);
  delay(Time);
  nosound;
end;

Function GetFreeConventionalMemory : LongInt;
Var
  Regs : Registers;
begin
  Regs.AH := $48;
  Regs.BX := $FFFF;
  Intr($21,Regs);
  GetFreeConventionalMemory := LongInt(Regs.BX)*16;
end;

procedure SwapStrings(var swapping:string;stout:string;stin:string);
var f2:string;i:integer;
begin
     f2:='';
     for i:=1 to length(swapping) do
     begin
     if (copy(swapping,i,1))=stout then
     f2:=f2+stin else
     f2:=f2+copy(swapping,i,1);
     end;
     swapping:=f2;
end;
procedure Ring;
var i:word;
begin
  for i:=0 to 6 do
  begin
      sound(523); asm hlt end;
  Delay(50);
      sound(659); asm hlt end;
  Delay(50);
  end;
  nosound
end;
Function BytesPerChar:Byte;
begin
  regs.ah:=$11;
  regs.al:=$30;
  regs.bh:=$00;
  Intr($10,regs);
  bytesperchar:=regs.cx;
end;
Procedure InitVGAProgressBar(x,y:integer);
begin
GotoXY(x,y);
Writeln('ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»');
GotoXY(x,y+1);
Writeln('º                               º');
GotoXY(x,y+2);
Writeln('ºÀÄÄÁÄÄÁÄÄÁÄÄÁÄÄÁÄÄÁÄÄÁÄÄÁÄÄÁÄÄÙº');
GotoXY(x,y+3);
Writeln('ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼');
GotoXY(x+1,y+1);
end;
Procedure VGAProgressBar(x,y:integer;pvalue,pofvalue:longint);
{Based on program written by Wim van der Vegt}

Var
  r     : registers;
  i,k   : Byte;
  bperc : Byte;
  procent,ilzn,ilkr: integer;
Const
  c : Array[1..16] Of Byte = (255,255,255,255,
                              255,255,255,255,
                              255,255,255,255,
                              255,255,255,255);

Procedure Reprogram(i,bperc : Byte);

VAR
  j : integer;
  r : registers;
  w : Word;

Begin
   w:=0;
   FOR j:=1 TO i DO w:=w+BYTE(256 SHR j);
   For j:=1 To bperc Do c[j]:=w;

   r.ah:=$11;
   r.al:=$10;
   r.bh:=bperc;
   r.bl:=$00;
   r.cx:=$01;
   r.dx:=$01;
   r.bp:=Ofs(c);
   r.es:=Seg(c);
   WaitForRetrace;
   Intr($10,r);
   hidecursor;
End; {of Reprogram}

Begin
TextColor(DarkGray);
bperc:=BytesPerChar;
{ Calculate position }
procent:=trunc(pvalue*(248/pofvalue));
ilzn:=trunc(procent/8);
ilkr:=procent-ilzn*8;
{----Do a 30 character bar}
For k:=1 To ilzn Do
    Begin
    {----Use chr(1) to animate, however wipe it before writing it}
      Reprogram(0,bperc);
      Write(#01);
    {----Animate character #1}
      For i:=0 To ilkr Do
        Begin
        {----calc bit new patterns,
             bit patterns are reversed in character generator,
             bit 7 is on the left side of a character}
          Reprogram(i,bperc);
        End;
   {----Replace fully animated characters by a full block from
        the line drawing set because animation of character #1
        will be started all over}
     GotoXY(WhereX-1,WhereY);
     Write('Û');
    End;
{    Writeln;}
end;
Procedure VGAProgressBar2(x,y:integer;pvalue,pofvalue:longint);
var procent:integer;
const bar31:string='±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±';
begin

TextColor(DarkGray);
{ Calculate position }
procent:=trunc(pvalue*(31/pofvalue));
GotoXY(x+1,y+1);
Writeln(copy(bar31,1,procent));
end;

Function ToUpper(S : string) : string; assembler;
Asm
  PUSH DS
  CLD
  LDS SI,S
  LES DI,@Result
  LODSB
  STOSB
  XOR AH,AH
  XCHG AX,CX
  JCXZ @@3
@@1:
  LODSB
  CMP AL,'a'
  JB  @@2
  CMP AL,'z'
  JA  @@2
  SUB AL,20h
@@2:
  STOSB
  LOOP @@1
@@3:
  POP DS
End; { ToUpper }

Procedure PutChar(ch:char);
begin
Mem[$b800:((WhereY-1)*160+(WhereX-1)*2)]:=Ord(Ch);
end;

Procedure DrawCharFrame(x1,y1,x2,y2,t:integer);
var cclu,ccld,ccru,ccrd,ccvr,cchr:char;
    i:integer;
begin
If t=1 then begin
cclu:='É';
ccld:='È';
ccru:='»';
ccrd:='¼';
ccvr:='º';
cchr:='Í';
end else if t=2 then begin
cclu:='Ú';
ccld:='À';
ccru:='¿';
ccrd:='Ù';
ccvr:='³';
cchr:='Ä';
end else begin
cclu:='Û';
ccld:='Û';
ccru:='Û';
ccrd:='Û';
ccvr:='Û';
cchr:='Û';
end;
GotoXY(x1,y1);PutChar(cclu);
GotoXY(x2,y1);PutChar(ccru);
GotoXY(x1,y2);PutChar(ccld);
GotoXY(x2,y2);PutChar(ccrd);
For i:=x1+1 to x2-1 do begin GotoXY(i,y1);PutChar(cchr);end;
For i:=x1+1 to x2-1 do begin GotoXY(i,y2);PutChar(cchr);end;
For i:=y1+1 to y2-1 do begin GotoXY(x1,i);PutChar(ccvr);end;
For i:=y1+1 to y2-1 do begin GotoXY(x2,i);PutChar(ccvr);end;
end;

procedure quickwrite(x, y: byte; s: string; f, b: byte);  { direct video writes }
type  videolocation = record           { video memory locations }
        videodata: char;               { character displayed }
        videoattribute: byte;          { attributes }
        end;
var cnter: byte;
    videosegment: word;
    vidptr: ^videolocation;
    videomode: byte absolute $0040:$0049;
    scrncols: byte absolute $0040:$004a;
    monosystem: boolean;
begin
  monosystem := (videomode = 7);
  if monosystem then videosegment := $b000 else videosegment := $b800;
  vidptr := ptr(videosegment, 2*(scrncols*(y - 1) + (x - 1)));
  for cnter := 1 to length(s) do begin
    vidptr^.videoattribute := (b shl 4) + f;
    vidptr^.videodata := s[cnter];
    inc(vidptr);
    end;
  end;

Function Trim(s:string):string;
begin
  If length(s)>1 then
  begin
  While ((s[1]=' ') and (length(s)>1) and (s<>' ')) do s:=copy(s,2,length(s)-1);
  While (s[length(s)]=' ') do s:=copy(s,1,length(s)-1);
  end;
Trim:=s;
end;
Procedure ExtendedStr(x,rmin,rmax:real;precision:integer;var s:string);
var i:integer;
begin
   if precision=-1 then
   begin
   if (x>rmax) or (x<rmin) then
   str(x,s) else
   str(x:0:12,s);
   i:=length(s);
   if (pos('.',s)>0) and (pos('E',s)=0)then
   begin
   while (s[i]='0') do
         begin
            dec(i);
            s:=copy(s,1,i);
         end;
   if s='' then s:='0';
   if s[i]='.' then s:=copy(s,1,length(s)-1);
   end;
      end else
   begin
   if (x>rmax) or (x<rmin) then
   str(x,s) else
   str(x:0:precision,s);
   end;
end;

Procedure IncPause(HS : longint); assembler; { From: Andrew Eigus}
Asm
        mov     es,Seg0040
        mov     si,006Ch
        mov     dx,word ptr es:[si+2]
        mov     ax,word ptr es:[si]
        add     ax,word ptr [HS]
        adc     dx,word ptr [HS+2]
@@1:
        mov     bx,word ptr es:[si+2]
        cmp     word ptr es:[si+2],dx
        jl      @@1
        mov     cx,word ptr es:[si]
        cmp     word ptr es:[si],ax
        jl      @@1
End; { Pause }

FUNCTION WildComp(wild,name:string):boolean;
BEGIN
   WildComp:=FALSE;
   if name = '' then exit;
   CASE wild[1] of
      '*' : BEGIN
              if name[1]='.' then exit;
              if length(wild)=1 then WildComp:=TRUE;
              if (length(wild) > 1) and (wild[2]='.') and (length(name) > 0)
              then WildComp:=WildComp(copy(wild,3,length(wild)-2),
                   copy(name,pos('.',name)+1,length(name)-pos('.',name)));
            END;

       '?': BEGIN
              if ord(wild[0])=1
                 then WildComp:=TRUE
                 else WildComp:=WildComp(copy(wild,2,length(wild)-1),
                                         copy(name,2,length(name)-1));
            END;

       ELSE if name[1] = wild[1]
                 then if length(wild) > 1
                      then WildComp:=WildComp(copy(wild,2,length(wild)-1),
                                              copy(name,2,length(name)-1))
                      else if (length(name)=1)
                           and (length(wild)=1)
                           then WildComp:=TRUE
                 else WildComp:=FALSE;
   END;
END;

Function Hex(Num : longint; Places : byte) : string;
const HexTab : array[0..15] of Char = '0123456789ABCDEF';
var
  HS : string[8];
  Digit : byte;
Begin
  HS[0] := Chr(Places);
  for Digit := Places downto 1 do
  begin
    HS[Digit] := HexTab[Num and $0000000F];
    Num := Num shr 4
  end;
  Hex := HS;
End; { Hex }
FUNCTION PtrToLong( P:POINTER ) :LONGINT; ASSEMBLER;
                     { Routine to convert a pointer to a 32 bit number. }
ASM
  Mov AX,P.WORD[0]                 { Load low WORD into AX.             }
  Mov DX,P.WORD[2]                 { Load high WORD into DX.            }
END;{PtrToLong}

Function ByteTest(T:longint; pos:byte):boolean;
Begin
     ByteTest:=(T and (longint(1) shl Pos)<>0);
End;

Procedure ByteSet(Var T:longint; Pos:byte);
Begin
     T:=T or (Longint(1) Shl Pos);
End;

Procedure ByteClear(Var T:longint; Pos:byte);
Begin
     T:=T and not (Longint(1) Shl Pos);
End;

Procedure ByteChange(Var T:longint; Pos:byte);
Begin
     T:=T xor (Longint(1) Shl Pos);
End;

function RedirectSetOutput(FileName: PathStr): Boolean;
begin
  FileName:=FileName+#0;
  RedirectSetOutput:=False;
  asm
    push  ds
    mov   ax, ss
    mov   ds, ax
    lea   dx, FileName[1]
    mov   ah, 3Ch
    int   21h
    pop   ds
    jnc   @@1
    ret
@@1:
    push  ax
    mov   bx, ax
    mov   cx, Output.FileRec.Handle
    mov   ah, 46h
    int   21h
    mov   ah, 3Eh
    pop   bx
    jnc   @@2
    ret
@@2:
    int   21h
  end;
  OutRedir:=True;
  RedirectSetOutput:=True;
end;

procedure RedirectCancelOutput;
var
  FileName: String[4];
begin
  if not OutRedir then Exit;
  FileName:='CON'#0;
  asm
    push  ds
    mov   ax, ss
    mov   ds, ax
    lea   dx, FileName[1]
    mov   ax, 3D01h
    int   21h
    pop   ds
    jnc   @@1
    ret
@@1:
    push  ax
    mov   bx, ax
    mov   cx, Output.FileRec.Handle
    mov   ah, 46h
    int   21h
    mov   ah, 3Eh
    pop   bx
    int   21h
  end;
  OutRedir:=False;
end;
Procedure RangesR(var x:real;l,h:real);
begin
   if (x>h) then x:=h;
   if (x<l) then x:=l;
end;
Procedure RangesI(var x:longint;l,h:longint);
begin
   if (x>h) then x:=h;
   if (x<l) then x:=l;
end;
Function PosLast(f:string;s:string):integer;
var i,j:integer;
begin
     j:=length(f);
     i:=length(s)-j;
     Repeat
     dec(i);
     until (i=0) or (Copy(s,i,j)=f);
     PosLast:=i;
end;
FUNCTION Win3X :BOOLEAN;  ASSEMBLER;
                {  Routine to determine if Windows is currently running }
ASM
  Mov AX,$4680                          {  Win 3.x Standard check       }
  Int $2F                               {  Call Int 2F                  }
  Cmp AX,0                              {  IF AX = 0 Win in real mode   }
  JNE @EnhancedCheck                    {  If not check for enhanced mode}
  Mov AL,1                              {  Set Result to true           }
  Jmp @Exit                             {  Go to end of routine         }
@EnhancedCheck:                         {  Else check for enhanced mode }
  Mov AX,$1600                          {  Win 3.x Enhanced check       }
  Int $2F                               {  Call Int 2F                  }
  Cmp AL,0                              {  Check returned value         }
  Je @False                             {  If not one of the below it   }
  Cmp AL,$80                            {  is NOT installed             }
  Je @False
  Mov AL,1                              {  Nope it must BE INSTALLED    }
  Jmp @Exit
@False:
  Mov AL,0                              {  Set Result to False          }
@Exit:
END;{Win3X}

FUNCTION WinVer :WORD;  ASSEMBLER;
                {  Returns a word containing the version of Win Running }
                {  Should only be used after checking for Win installed }
                {  Or value returned will be meaning less               }
ASM
  Mov AX,$1600                     {    Enhanced mode check             }
  Int $2F                          {    Call Int 2F                     }
END;{WinVer}

Procedure CWriteln(s:string);
var i:integer;
begin
For i:=1 to Round((80-length(s))/2) do write(' ');
Writeln(s);
end;

Procedure RWriteln(s:string);
var i:integer;
begin
For i:=1 to (80-length(s)) do write(' ');
Writeln(s);
end;

Function DosErrorText(a:integer):string;
var s:string;
begin
case a of
 1,0:s:='No error';
 2  :s:='File not found';
 3  :s:='Path not found';
 5  :s:='Access denied';
 6  :s:='Invalid handle';
 8  :s:='Not enough memory';
10  :s:='Invalid environment';
11  :s:='Invalid format';
18  :s:='No more files';
100 :s:='Disk read error';
101 :s:='Disk write error';
102 :s:='File not assigned';
103 :s:='File not open';
104 :s:='File not open for input';
105 :s:='File not open for output';
106 :s:='Invalid numeric format';
150 :s:='Disk is write-protected';
151 :s:='Bad drive request struct length';
152 :s:='Drive not ready';
154 :s:='CRC error in data';
156 :s:='Disk seek error';
157 :s:='Unknown media type';
158 :s:='Sector Not Found';
159 :s:='Printer out of paper';
160 :s:='Device write fault';
161 :s:='Device read fault';
162 :s:='Hardware failure';
200 :s:='Division by zero';
201 :s:='Range check error';
202 :s:='Stack overflow error';
203 :s:='Heap overflow error';
204 :s:='Invalid pointer operation';
205 :s:='Floating point overflow';
206 :s:='Floating point underflow';
207 :s:='Invalid floating point operation';
208 :s:='Overlay manager not installed';
209 :s:='Overlay file read error';
210 :s:='Object not initialized';
211 :s:='Call to abstract method';
212 :s:='Stream registration error';
213 :s:='Collection index out of range';
214 :s:='Collection overflow error';
215 :s:='Arithmetic overflow error';
216 :s:='General Protection fault';
end;
DosErrorText:=s;
end;

Function IOErrorText(a:integer):string;
var s:string;
begin
case a of
  0 :s:='No error';
  1 :s:='Invalid function number';
  2 :s:='File not found';
  3 :s:='Path not found';
  4 :s:='Too many open files';
  5 :s:='File access denied';
  6 :s:='Invalid file handle';
 12 :s:='Invalid file access code';
 15 :s:='Invalid drive number';
 16 :s:='Cannot remove current directory';
 17 :s:='Cannot rename across drives';
 18 :s:='No more files';
100 :s:='Disk read error';
101 :s:='Disk write error';
102 :s:='File not assigned';
103 :s:='File not open';
104 :s:='File not open for input';
105 :s:='File not open for output';
106 :s:='Invalid numeric format';
150 :s:='Disk is write-protected';
151 :s:='Bad drive request struct length';
152 :s:='Drive not ready';
154 :s:='CRC error in data';
156 :s:='Disk seek error';
157 :s:='Unknown media type';
158 :s:='Sector Not Found';
159 :s:='Printer out of paper';
160 :s:='Device write fault';
161 :s:='Device read fault';
162 :s:='Hardware failure';
200 :s:='Division by zero';
201 :s:='Range check error';
202 :s:='Stack overflow error';
203 :s:='Heap overflow error';
204 :s:='Invalid pointer operation';
205 :s:='Floating point overflow';
206 :s:='Floating point underflow';
207 :s:='Invalid floating point operation';
208 :s:='Overlay manager not installed';
209 :s:='Overlay file read error';
210 :s:='Object not initialized';
211 :s:='Call to abstract method';
212 :s:='Stream registration error';
213 :s:='Collection index out of range';
214 :s:='Collection overflow error';
215 :s:='Arithmetic overflow error';
216 :s:='General Protection fault';
end;
IOErrorText:=s;
end;

Function UsingInt(a:longint):string;
var s,s1:string;
begin
s1:='';
Str(a,s);
While (length(s)>3) do
begin
s1:=' '+Copy(s,length(s)-2,3)+s1;
s:=Copy(s,1,length(s)-3);
end;
s1:=s+s1;
UsingInt:=s1;
end;

Function UsingReal(a:real):string;
var s,s1:string;
begin
s1:='';
Str(a:0:0,s);
While (length(s)>3) do
begin
s1:=' '+Copy(s,length(s)-2,3)+s1;
s:=Copy(s,1,length(s)-3);
end;
s1:=s+s1;
UsingReal:=s1;
end;

Procedure AddExt(var s:string;e:string);
begin
if Pos(e,s)=0 then s:=s+e;
end;

{Procedure GetIntAddr(nint:byte;var is,io:word);

begin
asm
   mov AH,$35
   mov AL,nInt
   Int $25
   mov BX,ES
   mov is,Word(BX)
   mov io,BX
end;
end;}

Procedure ClickAsm; Assembler;
Asm
  in  al, $61
  xor al, 2
  out $61, al
end;

Procedure StandardIO; Begin
Assign( Input, '' );Reset( Input );Assign( Output, '' );ReWrite( Output ); End;

END.