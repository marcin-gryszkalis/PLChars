Unit IncDisk;
Interface
Uses dos,IncMiscs;

Type
SectBuff=Array[0..511] of Byte;

Type DiskBaseTable = Record {INT 1E vector -> DBT}
SByte1:Byte;
SByte2:Byte;
MotorDelay:Byte;
BytesPerSector:Byte;
SectorsPerTrack:Byte;
SectorGapRW:Byte;
DataLength:Byte;
SectorGapFormat:Byte;
FormatFill:Byte;
HeadSettleTime:Byte;
MotorStartTime:Byte;
End;

{Format of diskette parameter table:
Offset  Size    Description     (Table 0572)
 00h    BYTE    first specify byte
                bits 7-4: step rate
                bits 3-0: head unload time (0Fh = 240 ms)
 01h    BYTE    second specify byte
                bits 7-1: head load time (01h = 4 ms)
                bit    0: non-DMA mode (always 0)
 02h    BYTE    delay until motor turned off (in clock ticks)
 03h    BYTE    bytes per sector (00h = 128, 01h = 256, 02h = 512, 03h = 1024)
 04h    BYTE    sectors per track
 05h    BYTE    length of gap between sectors (2Ah for 5.25", 1Bh for 3.5")
 06h    BYTE    data length (ignored if bytes-per-sector field nonzero)
 07h    BYTE    gap length when formatting (50h for 5.25", 6Ch for 3.5")
 08h    BYTE    format filler byte (default F6h)
 09h    BYTE    head settle time in milliseconds
 0Ah    BYTE    motor start time in 1/8 seconds}

Const
BPSec:array[0..3] of word=(128,256,512,1024);
DrvType:array[1..6] of string[5]=('360K ','1.2M ','720K ','1.44M','Unkn.','1.88M');

Function  FileExist( F:String ):Boolean;
Function  DirExist( Dir: String ) : Boolean;
Function  VerifySect( Sect:Word; Drive:Byte): Byte;
Function  ReadSect( Sect:Word; Drive:Byte; Var buff:SectBuff ): Byte;
Function  ReadSectHDD( Sect:Word; Drive:Byte; Var buff:SectBuff ): Byte;
Function  WriteSect( Sect:Word; Drive:Byte; Var buff:SectBuff ): Byte;
Function  WriteSectHDD( Sect:Word; Drive:Byte; Var buff:SectBuff ): Byte;
Function  LegalDir(path:String):Boolean;
Procedure MakeDirectory(st:String;Var perror:Integer);
Function  FindFileInPath(f:string):string;
Function  AddBackSlash(s:string):string;
function  EXESize(fname : string) : longint;{Steve Rogers}
procedure DriveMotorTurnOn(drive:byte);{A-0,B-1} {D.J. Murdoch}
procedure DriveMotorTurnOff(drive:byte); {ditto}
Function  clustsize (drive : Byte) : Word;
Procedure Dump(fn:string);
function  diskchange(drive:byte):boolean;
Function  DriveSize(d : byte) : Longint; { -1 not found, 1=>1 Giga }
Function  DriveFree(d : byte) : Longint; { -1 not found, 1=>1 Giga }
Function  GetDiskOperationStatus(i:byte):string;

Implementation
Function FileExist;
Var
X: SearchRec;
Begin
   FindFirst(F, AnyFile, X);
   FileExist:= DosError = 0;
End;                                                            { FileExists }

Function    VerifySect( Sect:Word; Drive:Byte): Byte;
Var Reg:Registers;
i:Word;
Begin
   With Reg do
   Begin
      AH:=4;                                                       {funkcja 4}
      AL:=1;                                                 {liczba sektorow}
      CH:=Sect div 18;                                                 {track}
      i:=Round(((sect/18)-CH)*18);
      CL:=(i mod 9)+1;                                                {sector}
      DH:=i div 9;                                                      {side}
      DL:=drive;                                                       {drive}
      Intr($13,Reg);
      VerifySect:=AH;
   End;
End;                                                              {VerifySect}

Function    ReadSectHDD( Sect:Word; Drive:Byte; Var buff:SectBuff ): Byte;
Var Reg:Registers;
i:Word;
Begin
   With Reg do
   Begin
      AH:=2;                                                       {funkcja 2}
      writeln(reg.ah);
      AL:=1;                                                 {liczba sektorow}
      writeln(reg.al);
      CH:=Sect div 18;                                                 {track}
      writeln(reg.ch);
      i:=Round(((sect/18)-CH)*18);
      CL:=(i mod 9)+1;                                                {sector}
      writeln(reg.cl);
      DH:=i div 9;                                                    {side}
      writeln(reg.dh);
      DL:=drive;                                                       {drive}
      writeln(reg.dl);
      ES:=Seg(buff);                                                  {buffor}
      BX:=Ofs(buff);
      Intr($13,Reg);
      ReadSectHDD:=AH;
   End;
End;                                                                {ReadSect}

Function    ReadSect( Sect:Word; Drive:Byte; Var buff:SectBuff ): Byte;
Var Reg:Registers;
i:Word;
Begin
   With Reg do
   Begin
      AH:=2;                                                       {funkcja 2}
      AL:=1;                                                 {liczba sektorow}
      CH:=Sect div 18;                                                 {track}
      i:=Round(((sect/18)-CH)*18);
      CL:=(i mod 9)+1;                                                {sector}
      DH:=i div 9;                                                      {side}
      DL:=drive;                                                  {drive}
      ES:=Seg(buff);                                                  {buffor}
      BX:=Ofs(buff);
      Intr($13,Reg);
      ReadSect:=AH;
   End;
End;                                                                {ReadSect}

Function    WriteSect( Sect:Word; Drive:Byte; Var buff:SectBuff ): Byte;
Var Reg:Registers;
i:Word;
Begin
   With Reg do
   Begin
      AH:=3;                                                       {funkcja 3}
      AL:=1;                                                 {liczba sektorow}
      CH:=Sect div 18;                                                 {track}
      i:=Round(((sect/18)-CH)*18);
      CL:=(i mod 9)+1;                                                {sector}
      DH:=i div 9;                                                      {side}
      DL:=drive;                                                       {drive}
      ES:=Seg(buff);                                                  {buffor}
      BX:=Ofs(buff);
      Intr($13,Reg);
      WriteSect:=AH;
   End;
End;                                                               {WriteSect}

Function    WriteSectHDD( Sect:Word; Drive:Byte; Var buff:SectBuff ): Byte;
Var Reg:Registers;
i:Word;
Begin
   With Reg do
   Begin
      AH:=3;                                                       {funkcja 3}
      AL:=1;                                                 {liczba sektorow}
      CH:=Sect div 18;                                                 {track}
      i:=Round(((sect/18)-CH)*18);
      CL:=(i mod 9)+1;                                                {sector}
      DH:=i div 9;                                                      {side}
      DL:=drive+128;                                                       {drive}
      ES:=Seg(buff);                                                  {buffor}
      BX:=Ofs(buff);
      Intr($13,Reg);
      WriteSectHDD:=AH;
   End;
End;                                                               {WriteSect}
Function DirExist( Dir: String ) : Boolean;
Var
fHandle: File;
wAttr: WORD;
Begin
   While Dir[Length(Dir)] = '\' do DEC( Dir[0] );
   Dir := Dir + '\.';
   Assign( fHandle, Dir );
   GETFATTR( fHandle, wAttr );
   DirExist := ( (wAttr AND DIRECTORY) = DIRECTORY );
End;

Function LegalDir(path:String):Boolean;
Var flag:Boolean;
Begin
{         path:=short(path);}
   flag:=True;
   If path[1]<'A' then flag:=False;
   If path[1]>'Z' then flag:=False;
   If path[2]<>':' then flag:=False;
   If path[3]<>'\' then flag:=False;
   Delete(path,1,3);
   While path<>'' do
   Begin
      If Pos('\',path)>9 then flag:=False;
      If ((length(path)>1) and (path[1]='\') and (path[2]='\'))
      Then flag:=False;
      If path[1]=' ' then flag:=False;
      If  not (path[1] in
                             ['A','B','C','D','E','F','G','H','I','J','K','L','M',
            'N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
            '1','2','3','4','5','6','7','8','9','0','_','^','$',
            '~','!','#','%','&','-','{','}','(',')','\'])
            Then flag:=False;
            Delete(path,1,1);
         End;
         LegalDir:=flag;
      End;

      Procedure MakeDirectory(st:String;Var perror:Integer);
      Var ns:String;
      ior:word;
      Begin
{$I-}
         Chdir(st);
         If IOResult=0 then exit;
         MKDIR(st);
         ior:=IOResult;
         If ior=3 then
         Begin
            ns:=st;
            While ns[Length(ns)]<>'\' do Delete(ns,Length(ns),1);
            Delete(ns,Length(ns),1);
            MakeDirectory(ns,pError);
            MakeDirectory(st,pError);
         End;
         If ((ior<>0) and (ior<>3)) then pError:=ior else perror:=0;
{$I+}
      End;

Function FindFileInPath(f:string):string;
var
p,p1:string;
i,j:integer;

begin
if FileExist(f) then
   begin
   GetDir(0,p);
   FindFileInPath:=AddBackSlash(p)+f;
   end
else
    begin
    p:=Copy(paramstr(0),1,PosLast('\',paramstr(0)));
    if FileExist(p+f) then FindFileInPath:=p+f
       else
       begin
       p:=FSearch(f,GetEnv('PATH'));
       if p<>'' then FindFileInPath:=p else FindFileInPath:='';
       end;
    end;
end;

Function  AddBackSlash(s:string):string;
begin
If S[length(s)]<>'\' then s:=s+'\';
AddBackSlash:=s;
end;

function EXESize(fname : string) : longint;
{ Returns size of executable code in EXE file }

type
  tSizeRec=record    { first 6 bytes of EXE header }
    mz,
    remainder,
    pages : word;
  end;
var
  f : file of tSizeRec;
  sz : tSizeRec;

begin
  assign(f,fname);
  reset(f);
  if (ioresult<>0) then EXESize:= 0 else begin
    read(f,sz);
    close(f);
    with sz do EXESize:= remainder+(longint(pred(pages))*512);
  end;
end;

procedure DriveMotorTurnOn(drive:byte);
{ Remember to wait about a half second before trying to read! }
begin
     port[$3F2] := 12 + drive + 1 SHL (4 + drive);
end;

procedure DriveMotorTurnOff(drive:byte);
{ drive A = 0, drive B = 1 }
begin
     port[$3F2] := 12 + drive;
end;
Function clustsize (drive : Byte) : Word;
Var
  regs : Registers;
begin
  regs.cx := 0;         {set For error-checking just to be sure}
  regs.ax := $3600;     {get free space}
  regs.dx := drive;     {0=current, 1=a:, 2=b:, etc.}
  msDos (regs);
  clustsize := regs.ax * regs.cx;      {cluster size!}
end;

Procedure Dump(fn:string);
var f:text; s:string;
begin
assign(f,fn);
Reset(f);
Repeat readln(f,s);Writeln(s); until Eof(f);
close(f);
end;

function diskchange(drive:byte):boolean;Assembler;
 asm
  Mov AH,16h;
  mov DL, Byte Ptr Drive;
  Int 13h;
  Mov AL, AH;
 End;

Function DriveSize(d : byte) : Longint; { -1 not found, 1=>1 Giga }
Var
  R : Registers;
Begin
  With R Do
  Begin
    ah := $36;
    dl := d;
    Intr($21, R);
    If AX = $FFFF Then
      DriveSize := -1 { Drive not found }
    Else
    If (DX = $FFFF) or (Longint(ax) * cx * dx = 1073725440) Then
      DriveSize := 1
    Else
      DriveSize := Longint(ax) * cx * dx;
  End;
End;

Function DriveFree(d : byte) : Longint; { -1 not found, 1=>1 Giga }
Var
  R : Registers;
Begin
  With R Do
  Begin
    ah := $36;
    dl := d;
    Intr($21, R);
    If AX = $FFFF Then
    DriveFree := -1 { Drive not found }
    Else
    If (BX = $FFFF) or (Longint(ax) * bx * cx = 1073725440) Then
      DriveFree := 1
    Else
      DriveFree := Longint(ax) * bx * cx;
  End;
End;

Function GetDiskOperationStatus(i:byte):string;
var s:string;
begin
Case i of

$00:s:='successful completion';
$01:s:='invalid function in Ah or invalid parameter';
$02:s:='address mark not found';
$03:s:='disk write-protected';
$04:s:='sector not found/read error';
$05:s:='reset failed (hard disk)';
$05:s:='data did not verify correctly (TI Professional PC)';
$06:s:='disk changed (floppy)';
$07:s:='drive parameter activity failed (hard disk)';
$08:s:='DMA overrun';
$09:s:='data boundary error (attempted DMA across 64K boundary or >80h sectors)';
$0A:s:='bad sector detected (hard disk)';
$0B:s:='bad track detected (hard disk)';
$0C:s:='unsupported track or invalid media';
$0D:s:='invalid number of sectors on format (PS/2 hard disk)';
$0E:s:='control data address mark detected (hard disk)';
$0F:s:='DMA arbitration level out of range (hard disk)';
$10:s:='uncorrectable CRC or ECC error on read';
$11:s:='data ECC corrected (hard disk)';
$20:s:='controller failure';
$31:s:='no media in drive (IBM/MS INT 13 extensions)';
$32:s:='incorrect drive type stored in CMOS (Compaq)';
$40:s:='seek failed';
$80:s:='timeout (not ready)';
$AA:s:='drive not ready (hard disk)';
$B0:s:='volume not locked in drive (INT 13 extensions)';
$B1:s:='volume locked in drive (INT 13 extensions)';
$B2:s:='volume not removable (INT 13 extensions)';
$B3:s:='volume in use (INT 13 extensions)';
$B4:s:='lock count exceeded (INT 13 extensions)';
$B5:s:='valid eject request failed (INT 13 extensions)';
$BB:s:='undefined error (hard disk)';
$CC:s:='write fault (hard disk)';
$E0:s:='status register error (hard disk)';
$FF:s:='sense operation failed (hard disk)';
else s:='unknown fail'
end;
GetDiskOperationStatus:=s;
end;

End.
