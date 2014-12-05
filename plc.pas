{spread}{$A+,B-,D-,E+,F-,G+,I-,L-,N+,O-,P+,Q-,R-,S-,T-,V-,X+,Y-}
{4debug}{ A+,B-,D+,E+,F-,G+,I-,L+,N+,O-,P+,Q+,R+,S+,T-,V+,X+,Y+}
{$M 16384,80000,80000}
Program plc53;
Uses incmiscs,incdisk,dos,altcrt;

Type filesT=Array[1..5041] of String[12];           { 5041x(12+1)=64K }

Type plc=Record
code:String[3];
name:String[40];
table:Array[1..18] of Byte;
End;

const
banner:string=
'PLChars converter v5.3 freeware by Marcin Gryszkalis dagoon@rs.math.uni.lodz.pl ';
stno=34;
bufsize=$8000;
                                               { A   C   E   L   N   O   S   Z   Z   a   c   e   l   n   o   s   z   z (z'zø)}
p:Array[1..stno] of plc=(
(code:'BEZ';name:'Bez polskich znakow   ';table:( 65, 67, 69, 76, 78, 79, 83, 90, 90, 97, 99,101,108,110,111,115,122,122)),
(code:'ADB';name:'Adobe Type Manager    ';table:(196,199,203,208,209,211,214,218,220,228,231,235,240,241,243,246,250,252)),
(code:'AMI';name:'AmigaPL               ';table:(194,202,203,206,207,211,212,218,219,226,234,235,238,239,243,244,250,251)),
(code:'ST ';name:'Atari ST              ';table:(193,194,195,196,197,198,199,200,201,209,210,211,212,213,214,215,216,217)),
(code:'ST2';name:'Atari ST (z-z)        ';table:(193,194,195,196,197,198,199,201,200,209,210,211,212,213,214,215,217,216)),
(code:'COR';name:'Corel 2.0             ';table:(194,199,202,206,209,211,212,218,219,226,231,234,238,241,243,244,250,251)),
(code:'CSK';name:'CSK                   ';table:(128,129,130,131,132,133,134,136,135,160,161,162,163,164,165,166,168,167)),
(code:'CRD';name:'Corel Draw            ';table:(197,242,201,163,209,211,255,225,237,229,236,230,198,241,243,165,170,186)),
(code:'CFR';name:'Cyfromat              ';table:(128,129,130,131,132,133,134,136,135,144,145,146,147,148,149,150,152,151)),
(code:'DHN';name:'DHN / ChiWriter pl    ';table:(128,129,130,131,132,133,134,136,135,137,138,139,140,141,142,143,145,144)),
(code:'EFT';name:'Efekt                 ';table:(128,130,131,133,134,135,136,139,138,140,141,143,144,145,146,147,150,149)),
(code:'ELW';name:'Elwro CP/J            ';table:(193,195,197,204,206,207,211,218,217,225,227,229,236,238,239,243,250,249)),
(code:'FAT';name:'Fat Agnus zine        ';table:(192,193,194,195,196,197,198,200,199,230,231,234,238,241,243,245,251,254)),
(code:'HCT';name:'Hector                ';table:(143,151,144,146,165,153,142,173,154,134,149,130,145,164,148,132,168,129)),
(code:'IEA';name:'IEA Swierk            ';table:(143,128,144,156,165,153,235,157,146,160,155,130,159,164,162,135,168,145)),
(code:'IIN';name:'IINTE-ISIS            ';table:(128,129,130,131,132,133,134,135,136,144,145,146,147,148,149,150,151,152)),
(code:'ISO';name:'ISO 8859/2 Latin-2    ';table:(161,198,202,163,209,211,166,172,175,177,230,234,179,241,243,182,188,191)),
(code:'KWK';name:'KWK Club              ';table:(143,128,144,156,165,153,159,146,158,133,155,138,157,164,162,135,145,168)),
(code:'LAT';name:'Latin-2 (cp852)       ';table:(164,143,168,157,227,224,151,141,189,165,134,169,136,228,162,152,171,190)),
(code:'LOG';name:'Logic                 ';table:(128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145)),
(code:'WIN';name:'MS Windows (cp1250)   ';table:(165,198,202,163,209,211,140,143,175,185,230,234,179,241,243,156,159,191)),
(code:'MAC';name:'Macintosh v1          ';table:(129,130,228,241,246,175,234,243,244,140,141,171,194,126,191,167,189,197)),
(code:'MC2';name:'Macintosh v2          ';table:(132,140,162,252,193,238,229,143,251,136,141,171,184,196,151,230,144,253)),
(code:'MAZ';name:'Mazovia               ';table:(143,149,144,156,165,163,152,160,161,134,141,145,146,164,162,158,166,167)),
(code:'MFD';name:'Mazovia - Fido        ';table:(143,149,144,156,165,163,152,160,161,134,135,145,146,164,162,158,166,167)),
(code:'MIC';name:'Microvex              ';table:(143,128,144,156,165,147,152,157,146,160,155,130,159,164,162,135,168,145)),
(code:'FOR';name:'PC sp. Format         ';table:(128,130,132,134,136,138,140,142,144,129,131,133,135,137,139,141,143,145)),
(code:'PN3';name:'Polish Norm 3         ';table:(194,195,198,202,206,211,212,213,219,226,227,230,234,238,243,244,245,251)),
(code:'SKL';name:'Skalmierski           ';table:(128,129,130,131,132,133,134,136,135,137,138,139,140,141,142,143,145,144)),
(code:'TAG';name:'TAG                   ';table:(128,129,130,131,132,133,134,135,136,144,145,146,147,148,149,150,151,152)),
(code:'TEX';name:'TeX.pl                ';table:(129,130,134,138,139,211,145,153,155,161,162,166,170,171,243,177,185,187)),
(code:'VNT';name:'Ventura               ';table:(151,153,165,166,146,143,142,144,128,150,148,164,167,145,162,132,130,135)),
(code:'XJP';name:'XJP Amiga             ';table:(198,199,202,206,209,211,213,219,222,230,231,234,238,241,243,245,251,254)),
(code:'XRD';name:'XRD 2nd edition       ';table:(239,171,227,156,228,248,251,252,254,155,157,159,166,167,234,158,169,170)));

value:Array[1..18] of Integer=
{ •    œ ¥ £  ˜    ¡   †       ‘    ’   ¤   ¢   ž  ¦   § }
{2,1, 3,15,2,2,19,1,36,673,430, 888,1286, 87,531,544,46,671);}
{6,5,10,16,1,7,13,1,23,710,468,1052,1411, 88,592,618,55,812);}
{6,4, 9,16,2,7,13,1,18,617,402, 903,1192, 78,511,546,47,692);}
{7,4,10,19,2,7,15,1,19,797,506,1142,1480,100,657,684,61,866);}
{4,3, 6,12,1,5,10,1,12,547,355, 792,1022, 67,455,476,41,609);}
{3,2, 5, 9,1,3, 9,1,10,457,299, 655, 851, 56,373,396,35,502);}
(3,2, 5,10,1,3,11,1,13,718,517,1015,1437,102,654,612,60,723);
Var
i,j,l,filei:word;
sf,df,rf:File;
sr:SearchRec;
sft,dft,dftP,destext,s:String;
dftD:String;
sD:DirStr; sN:NameStr; sE:ExtStr;
filesn:Integer;
files:^filesT;
cdir:String;
t1,t2:Integer;

brk, {used to break working}
ok,
over, {/O set}
Delete, {/D set}
ForceT1, {/T:... set}
derr, {dos error happened}
dirC, {preserve current dir? (in cdir)}
Ass1st, {/A set}
alt2, {/2 set}
alt3, {/3 set}
Quiet, {/Q set}
AutoReplace, {/R set}
NoConversion { target not specified == no conversion }
:Boolean;

p1:String;
pn:Array[1..20] of String; { command line args }
ch:Char;
a:byte;
buf:Array[0..bufsize-1] of Byte; {io buffer}
ttimer:longint; { for tick timer }
om:Integer; {old filemode}
a3_1v,a3_2v:array[1..stno] of Real; {for /3}
convtable:array[0..255] of Byte; {xlation table}
Label SKIP;

Procedure HaltX(i:Integer);
Begin
   filemode:=om;
   If DirC then chdir(cdir);
   If Quiet then RedirectCancelOutput;
   Dispose(files);
   Halt(i);
End;

Procedure FE(i:integer; ss:String);
Begin
   WriteLn('PLC fatal error [#',i,']: ',ss);
   WriteLn('Type "PLC /?" for info');
   HaltX(i)
End;

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

Procedure iocheck;
var io:integer;
Begin
   io:=IOResult;
   If io>0 then FE(io,DosErrorText(io));
End;

Procedure Sign;
Var  TickTimer : LongInt Absolute $0040:$006c;
Begin       {21 ticks/s => write one dot per s}
   if ((ttimer+21)<TickTimer) then
      begin
      ttimer:=TickTimer;
      Write('.');
      end;
End;

Procedure lin;
Var i:Byte;
Begin
   For i:=0 to 78 do Write('Ä');
   WriteLn;
End;

Procedure info;
Var kk:word;
Begin
   WriteLn(' PLC filename.ext [xxx] [ {/2|/3} /S:xxx /A /T:target.ext /D /O /R /Q /?]');
   WriteLn;
   WriteLn(' filename.ext - name of the source file. Wildcards allowed.');
   WriteLn(' xxx - code of destination polish chars standard');
   WriteLn(' /2 - alternative std analyser           /3 - both std analysers');
   WriteLn(' /S:xxx - force source standard          /D - delete source file afterwards');
   WriteLn(' /O - overwrite source file with target  /T:.. - name of target dir/file');
   WriteLn(' /A - use standard of first file for all matching filename.ext');
   Writeln(' /R - auto replace if target file exist  /Q - quiet mode (no screen output)');
   lin;
   WriteLn(' BEZ Bez polskich    DHN DHN/ChiWiterPl  KWK KWK Club       PN3 Polish Norm 3');
   WriteLn(' ADB Adobe Type      EFT Efekt           LAT Latin-2 cp852  SKL Skalmierski');
   WriteLn(' AMI AmigaPL         ELW Elwro Jnr CP/J  LOG Logic          TAG TAG');
   WriteLn(' ST  Atari ST        FAT Fat Agnus zine  WIN MS Win cp1250  TEX TeX.pl');
   WriteLn(' ST2 Atari ST (z-z)  FOR Format          MAC Macintosh v1   VNT Ventura');
   WriteLn(' COR Corel 2.0       HCT Hector          MC2 Macintosh v2   XJP XJP Amiga');
   WriteLn(' CSK CSK             IEA Inst.E.A.       MAZ Mazovia cp991  XRD XRD edition 2');
   WriteLn(' CRD Corel Draw      IIN IINTE-ISIS      MFD Fido Mazovia   ');
   WriteLn(' CFR Cyfromat        ISO ISO 8859/2 L2   MIC Microvex');

   lin;
   HaltX(0);
End;

Function CheckType(sft:String):Integer;
var
a1:Array[1..stno,1..18] of Real;
a1n:Array[1..stno] of Integer;                    {number of st. for sorting}
a1v:Array[1..stno] of Real;                      {sum(n=1,stno) of a1(x,n)}
xr,yr:Real; {to work with HUGE files (coz vals are huge)}
y1:Real;
i,k:word;

Begin
   For i:=1 to stno do
   Begin
      a1n[i]:=0;
      a1v[i]:=0;
      For j:=1 to 18 do
          a1[i,j]:=0;
   End;
   xr:=0;

   brk:=False;
   Assign(sf,sft);
   Reset(sf,1);
   iocheck;
   Write('Working..');
   Repeat
      If KeyPressed then
         Begin
         ch:=readkey;
         If ch=#27 then brk:=True;
         End;
      BlockRead(sf,buf,bufsize,l);
      iocheck;
      Sign;
      For i:=0 to l-1 do
      Begin
         If (buf[i] and $80)>0 then
            For k:=1 to stno do
                For j:=1 to 18 do
                    begin
                    If (p[k].table[j]=buf[i]) then
                       begin
                       a1[k,j]:=a1[k,j]+1;
                       break; {stop checking in this standard}
                       end;
                    end;
      End;
   Until (l<bufsize-1) or (brk);
   Close(sf);

   If brk then
      WriteLn('break!')
   Else
        WriteLn('finished.');

   WriteLn('');

   For i:=1 to stno do
       For j:=1 to 18 do
           a1v[i]:=a1v[i]+a1[i,j]*value[j];

   For i:=1 to stno do a1n[i]:=i;
   Repeat                                                             {bubble!}
      ok:=True;
      For i:=1 to stno-1 do
      If a1v[i]<a1v[i+1] then
      Begin
         ok:=False;
         yr:=a1v[i];
         a1v[i]:=a1v[i+1];
         a1v[i+1]:=yr;
         j:=a1n[i];
         a1n[i]:=a1n[i+1];
         a1n[i+1]:=j;
      End;
   Until ok;

   For i:=1 to 5 do xr:=xr+a1v[i];
   If xr>0 then
   Begin
      if not alt3 then
         begin
         Writeln('Standard:                              Probability:');
         end;
      For i:=1 to 5 do
      Begin
         y1:=a1v[i]*100/xr;

         if alt3 then
            a3_1v[a1n[i]]:=y1
         else
         If y1>0 then
         Begin
            Writeln(p[a1n[i]].name:22,y1:22:2,'%');
         End;
      End;
      checktype:=a1n[1];
      if not alt3 then WriteLn;
   End
   Else
   checktype:=0;

End;

Function CheckType2(sft:String):Integer;
var
a2n:Array[1..stno] of Integer;                    {number of st. for sorting}
a2v:Array[1..stno] of Real;
a2fails:Array[1..stno] of longint;
a2maxfail:longint;
a2found:boolean;
xr,yr:Real; {to work with HUGE files (coz vals are huge)}
y1:Real;
i,k:word;

Begin
   For i:=1 to stno do
       Begin
       a2fails[i]:=0;
       End;
   xr:=0;

   brk:=False;
   Assign(sf,sft);
   Reset(sf,1);
   iocheck;
   Write('Working..');
   Repeat
      If KeyPressed then
         Begin
         ch:=readkey;
         If ch=#27 then brk:=True;
         End;
      BlockRead(sf,buf,bufsize,l);
      iocheck;
      Sign;
      For i:=0 to l-1 do
      Begin
         If (buf[i] and $80)>0 then
            For k:=1 to stno do
                begin
                a2found:=false;
                For j:=1 to 18 do
                    If (p[k].table[j]=buf[i]) then
                       begin
                       a2found:=true;
                       break; {stop check in this std (break off j loop) }
                       end;
                if not a2found then inc(a2fails[k]);
                end;
      End;
   Until (l<bufsize-1) or (brk);
   Close(sf);

   If brk then
   WriteLn('break!')
   Else
   WriteLn('finished.');

   WriteLn;

   a2maxfail:=0;
   For i:=1 to stno do
       if a2fails[i]>a2maxfail then
          a2maxfail:=a2fails[i];

   For i:=1 to stno do
       a2v[i]:=a2maxfail-a2fails[i];

   For i:=1 to stno do a2n[i]:=i; {indeksy}

   Repeat                                                             {bubble!}
      ok:=True;
      For i:=1 to stno-1 do
      If a2v[i]<a2v[i+1] then
      Begin
         ok:=False;
         yr:=a2v[i];
         a2v[i]:=a2v[i+1];
         a2v[i+1]:=yr;
         j:=a2n[i];
         a2n[i]:=a2n[i+1];
         a2n[i+1]:=j;
      End;
   Until ok;

   For i:=1 to 5 do xr:=xr+a2v[i];
   If xr>0 then
   Begin
        if not alt3 then
        begin
      Writeln('Standard:                              Probability:');
      end;
      For i:=1 to 5 do
      Begin
         y1:=a2v[i]*100/xr;

         if alt3 then
            a3_2v[a2n[i]]:=y1
         else
         If y1>0 then
         Begin
            Writeln(p[a2n[i]].name:22,y1:22:2,'%');
         End;
      End;
      checktype2:=a2n[1];
      WriteLn;
   End
   Else
   checktype2:=0;

End;

Function CheckType3(sft:String):Integer;
var
a3n:Array[1..stno] of Integer;                    {number of st. for sorting}
a3v:array[1..stno] of Real;
i0,j0:integer;
i,j:word;
yr:Real;

begin
   i0:=checktype(sft);
   j0:=checktype2(sft);
   if i0+j0=0 then begin checktype3:=0; exit; end;

   for i:=1 to stno do a3v[i]:=(a3_1v[i]+a3_2v[i])/2;

   For i:=1 to stno do a3n[i]:=i; {indeksy}

   Repeat                                                             {bubble!}
      ok:=True;
      For i:=1 to stno-1 do
      If a3v[i]<a3v[i+1] then
      Begin
         ok:=False;
         yr:=a3v[i];
         a3v[i]:=a3v[i+1];
         a3v[i+1]:=yr;
         j:=a3n[i];
         a3n[i]:=a3n[i+1];
         a3n[i+1]:=j;
      End;
   Until ok;

   Writeln('Standard:                              Probability:');

   For i:=1 to 5 do
      Begin
         If a3v[i]>0 then
         Begin
            Writeln(p[a3n[i]].name:22,a3v[i]:22:2,'%');
         End;
      End;
      checktype3:=a3n[1];
      WriteLn;

End;

{--------------------------------------------------------------------}
{----------------------------MAIN------------------------------------}
{--------------------------------------------------------------------}

Begin

   StandardIO;
   New(files);
   om:=filemode;
   filemode:=0;
   dirC:=False;
   filesn:=0;
   over:=False;
   alt2:=False;
   alt3:=False;
   Delete:=False;
   ForceT1:=False;
   Ass1st:=False;
   Quiet:=False;
   AutoReplace:=False;
   t2:=0;

   For i:=2 to paramcount do pn[i]:=ToUpper(paramstr(i));

   For i:=2 to paramcount do
       Begin
       if ((pn[i][1]='-') or (pn[i][1]='/')) then
          if (pn[i][2]='Q') then
             begin
             Quiet:=True;
             redirectsetoutput('NUL');
             break;
             end;
      end;

   lin;
   CWriteLn(banner);
   lin;

   If (paramcount=0) then info;                                 {stop there...}

   p1:=ToUpper(paramstr(1));
   FSplit(p1,sD,sN,sE);
   If sD<>'' then
   Begin
      GetDir(0,cdir);
      DirC:=True;
      ChDir(sD);
      iocheck;
      p1:=sN+sE;
   End;

   derr:=False;
   For i:=2 to paramcount do
       Begin
       if ((pn[i][1]='-') or (pn[i][1]='/')) then
         case pn[i][2] of
         'O': over:=True;
         '2': alt2:=True;
         '3': alt3:=True;
         'D': Delete:=True;
         'A': Ass1st:=True;
         'Q': Quiet:=True;
         'R': AutoReplace:=True;
         'T':
            Begin
                  dftP:=Copy(pn[i],4,Length(pn[i])-3);
                  if (pos('*',dftP)>0) or (pos('?',dftP)>0) then
                     FE(241,'Wildcards cannot be used in destination filename (/T: switch)');
            end;
         'S':
            Begin
               ForceT1:=True;
               s:=Copy(pn[i],4,Length(pn[i])-3);
               For j:=1 to stno do
                   If s=trim(p[j].code) then t1:=j;
               If (t1<=0) or (t1>stno) then
               FE(242,'Unknown standard code.');
            End;
         end {case}
      else {standard code}
        begin
        For j:=1 to stno do
            If pn[i]=trim(p[j].code) then t2:=j;
        If (t2<=0) or (t2>stno) then FE(243,'Unknown standard code.');
        end;
   End;


   if t2=0 then NoConversion:=True;
   FindFirst(p1, $3f, sr);
   While ((doserror=0) and (derr=false)) do
   Begin
      While ((sr.Attr=$8) or (sr.Attr=$10) or (sr.name='PLC.EXE')) do
      Begin
         sr.name:='';
         sr.attr:=0;
         FindNext(sr);
         If doserror>0 then derr:=True;
      End;
      If not derr then
      Begin
         inc(filesn);
         files^[filesn]:=sr.Name;
         FindNext(sr);
      End;
   End;

   If filesn=0 then FE(244,'File not found.');
   s:=''; if filesn>1 then s:='s';
   If (Pos('?',p1)>0) or (Pos('*',p1)>0) then
   WriteLn('File mask: ',p1,' (',filesn,' file',s,')');

   For filei:=1 to filesn do
   Begin
      If filesn>1 then
      WriteLn('File ',filei,' of ',filesn,' - ',files^[filei])
      Else
      WriteLn('File: ',sD,files^[filei]);

      sft:=ToUpper(files^[filei]);

      If NoConversion then
      Begin
         WriteLn('Target standard code not specified. Standard Analyser launched.');
         if alt2 then Writeln('/2 option specified. Using Alternative Standard Analyser.');
         if alt3 then Writeln('/3 option specified. Using both Standard Analysers.');
         WriteLn;
         if alt2 then i:=checktype2(FExpand(sft))
         else if alt3 then i:=checktype3(FExpand(sft))
         else i:=checktype(FExpand(sft));

         If i=0 then WriteLn('No polish chars found.');
         Goto SKIP; {Goto? GOTO?! No... you can't do it this way! ;) }
      End;

      if ((dftP[length(dftP)]='\') or (dftP='')) then
         begin
         dftD:=dftP;
         dft:=sft;
         destext:='.PLC';
         i:=Pos('.',dft);
         If Copy(sft,i,4)='.PLC' then destext:='.PL2';
         If i<>0 then dft:=Copy(dft,1,i-1);
         dft:=dft+destext;
         if dftD='' then
            dft:=sD+dft
            else
            dft:=dftD+dft;
         end
      else
      dft:=dftP;

      If not FileExist(sft) then FE(245,'File '+sft+' not found.');

      If ((not ForceT1) and ( (not Ass1st) or (filei=1) )) then
         begin
         if alt3 then i:=checktype3(FExpand(sft))
         else if alt2 then i:=checktype2(FExpand(sft))
         else i:=checktype(FExpand(sft));
         t1:=i;
         end;

      If (t1=0) or (t1>stno) then
      Begin
         WriteLn('No polish chars found. File cannot be converted.');
         Goto SKIP;
      End;

      If t1=t2 then
      Begin
         WriteLn(sft,' is already in specified standard (',trim(p[t1].name),')');
         Goto SKIP;
      End;

      If FileExist(dft) then
      Begin
         if AutoReplace then
            begin
            writeln('Warning: old version of ',dft,' will be overwritten.');
            end
         else
            begin
            ok:=False;
            Repeat
               WriteLn('File ',dft,' exist! [O]verwrite [R]ename [S]kip [Q]uit ');
               ch:=readkey;
               If UpCase(Ch)='R' then
               Begin
                  s:=dft;
                  Assign(rf,dft);
                  Write('Enter new name: ');
                  ReadLn(s);
                  s:=ToUpper(s);
                  Rename(rf,s);
                  iocheck;
                  WriteLn(dft,' renamed to ',s);
                  WriteLn;
                  ok:=True;
               End;
               If UpCase(Ch)='Q' then
               Begin
                  lin;
                  HaltX(0);
               End;
               If UpCase(Ch)='S' then Goto SKIP;
               If UpCase(Ch)='O' then
               Begin
                  ok:=True;
                  WriteLn(dft,' will be overwritten.');
                  WriteLn;
               End;
            Until ok;
            end;
      End;

      WriteLn('Converting:');
      WriteLn(' ',sD,sft,' [',trim(p[t1].name),']');
      WriteLn('to ');
      WriteLn(' ',dft,' [',trim(p[t2].name),']');
      WriteLn;

      Assign(sf,FExpand(sft));
      Reset(sf,1);
      iocheck;
      Assign(df,dft);
      ReWrite(df,1);
      iocheck;
      Write('Working..');
      For i:=0 to 255 do convtable[i]:=i;
      For i:=1 to 18 do convtable[p[t1].table[i]]:=p[t2].table[i];
      Repeat
         BlockRead(sf,buf,bufsize,l);
         iocheck;
         Sign;
         asm
                pusha
                push ds
                pop es
                mov si, offset buf
                mov di, offset buf
                mov cx, l
                mov bx, offset convtable
           @l1: lodsb
                xlat
                stosb
                loop @l1
                popa
         end;
         BlockWrite(df,buf,l);
         iocheck;
      Until l<bufsize-1;

      Close(sf);
      iocheck;
      Close(df);
      iocheck;
      WriteLn('finished.');

      If over then
      Begin
         Erase(sf);
         iocheck;
         Rename(df,sft);
         iocheck;
         WriteLn(dft,' renamed to ',sft,'.');
      End;

      If Delete then
      Begin
         Erase(sf);
         iocheck;
         WriteLn(sft,' erased.');
      End;

      SKIP:

      lin;
   End;                                                      {search wildcards}
   HaltX(0);
End.
