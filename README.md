PLChars
=======

DOS charset converter for polish diacritical characters (legacy).


```
 ┌──────────────────────────────────────────────────────────────────────────┐
 │                                                                          │
 │         ▀██▀▀▀█▄▀██▀    ▄█▀▀▀█▄ ██  C O N V E R T E R  ver 5.3
 │          ██   ██ ██     ██   ▀▀ ██▄▄▄▄   ▄▄▄▄▄▄ ▄▄ ▄▄▄▄  ▄▄▄▄▄
 │          ██   ██ ██     ██      ██   ██ ██   ██  ██     ▀█▄▄
 │          ██▀▀▀▀  ██     ██   ▄▄ ██   ██ ██   ██  ██        ▀▀█▄
 │         ▄██▄    ▄██▄▄▄█ ▀█▄▄▄█▀ ██   ██ ▀█▄▄▀██ ▄██▄     ▄▄▄▄█▀
 │
 │            F R E E ─ W A R E   F O R   F R E E   P E O P L E
 │
 │               written by Marcin Gryszkalis (c) 1997 - 1999
 │
 └───────────────┐
     DESCRIPTION │
 ┌───────────────┘
 │
 │    PLC  is  file  converter  that  converts  ASCII  text  files  from/to
 │  different  standards  of coding polish diacritical chars. It support 34
 │  standards and can recognize standard of file (using two analysers).
 │
 └───────┐
     TIP │
 ┌───────┘
 │
 │    You   can  break  standard  analysis  with  ESC  key  (PLC  will  use
 │  information collected before break).
 │
 └──────────────┐
     DISCLAIMER │
 ┌──────────────┘
 │
 │    Here goes usual disclaimer and other useless stuff... [skipped]
 │
 └─────────┐
     USAGE │
 ┌─────────┘
 │
 │  PLC filename.ext [code] [options]
 │
 │    ¨  filename.ext - name of the source text file. You can use wildcards
 │  (like  *  and  ?)  to specify multiply files. You can specify full path
 │  (converted  file  will  be  saved  in  directory  where  source file is
 │  placed). If only filename is specified PLC will show standard of it.
 │    ¨  code - three-letter code of destination polish chars standard, eg.
 │  MAZ for Mazovia or LAT for Latin-2.
 │
 │  options:
 │
 │    ¨  /2 - use alternative method of recognizing standard.
 │    ¨  /3  -  use  both  (normal  and alternative) methods of recognizing
 │  standard.
 │    ¨  /S:code - force source standard, disable auto-recognizing
 │    ¨  /A  -  (useless when no wildcards specified) recognize standard in
 │  first file ONLY and assume rest of files being the same standard.
 │    ¨  /T:.. - name of target file, if not specified filename.PLC will be
 │  saved.  You  cannot  use  wildcards  in  /T parameter argument. You can
 │  specify full path and file or a path only (with ending '\').
 │    ¨  /D - delete source file afterwards
 │    ¨  /O - overwrite (rename destination file to source file afterwards)
 │    ¨  /R  -  auto  replace (if target file exist already then it will be
 │  overwritten without asking - see the "surprise" section in this doc)
 │    ¨  /Q - quiet mode (nothing is written to the screen)
 │    ¨  /? - short help
 │
 └────────────┐
     EXAMPLES │
 ┌────────────┘
 │
 │  PLC a1.txt                     -- recognizes standard of a1 and shows
 │                                    results on screen, no convertion
 │                                    performed
 │  PLC C:\OLD\a1.txt /2           -- same as above but a1.txt is not in
 │                                    current subdirectory and alternative
 │                                    analyser is used
 │  PLC a1.txt ISO /3              -- recognizes standard of a1.txt (using
 │                                    both analyzers) and converts it to
 │                                    a1.plc as ISO-Latin2
 │  PLC a1.txt ISO /T:a2.txt /3    -- same as above but saves a2.txt
 │  PLC a1.txt ISO /T:a2.txt /D /3 -- same as above but saves a2.txt and
 │                                    erases a1.txt
 │  PLC a1.txt ISO /T:C:\NEW\      -- saves a1.plc in NEW subdirectory on C:
 │                                    drive
 │  PLC a1.txt ISO /O              -- converts a1.txt to a1.plc, erases a1.
 │                                    txt, renames a1.plc to a1.txt
 │  PLC a1.txt ISO /S:MAZ          -- doesn't perform recognition, assumes
 │                                    a1.txt being in Mazovia standard and
 │                                    converts to a1.plc in ISO-Latin2
 │  PLC *.txt ISO /A               -- recognizes standard of first file
 │                                    matching *.txt mask (for exmaple -
 │                                    Mazovia), convert it to ISO
 │                                    and convert all other files matching
 │                                    *.txt from Mazovia to ISO.
 │
 └─────────────────┐
     FOOL EXAMPLES │
 ┌─────────────────┘
 │
 │  PLC a1.txt ISO /O /D          -- gives the same result as "DEL a1.txt"
 │                                   but takes more time and disk space ;)
 │  PLC a1.txt ISO /A             -- /A switch has nothing to do here
 │                                   (because PLC will work on 1 file only)
 │  PLC a1.txt ISO /T:a2.txt /O   -- works like /O only but uses s2.txt
 │                                   as a temporary file instead of default
 │                                   a1.plc
 └─────────────┐
     STANDARDS │
 ┌─────────────┘
 │
 │    Following standards are accepted and supported:
 │
 │  01. BEZ - Bez polskich znakow
 │  02. ADB - Adobe Type Manager (old)
 │  03. AMI - AmigaPL
 │  04. ST  - Atari ST
 │  05. ST2 - Atari ST (z-z)
 │  06. COR - Corel 2.0
 │  07. CSK - Computer Studio Kajkowski
 │  08. CRD - Corel Draw (old)
 │  09. CFR - Cyfromat
 │  10. DHN - Dom Handlowy Nauki / ChiWriter pl
 │  11. EFT - Efekt
 │  12. ELW - Elwro Junior (CP/J) or Rodos
 │  13. FAT - Fat Agnus zine (amiga)
 │  14. HCT - Hector / Univex
 │  15. IEA - Instytut Energii Atomowej (IEA) Swierk
 │  16. IIN - IINTE-ISIS
 │  17. ISO - ISO 8859/2 Latin-2
 │  18. KWK - KWK Club
 │  19. LAT - Latin-2 (cp852)
 │  20. LOG - Logic
 │  21. WIN - MS Windows 3.x (cp1250)
 │  22. MAC - Macintosh v1
 │  23. MC2 - Macintosh v2
 │  24. MAZ - Mazovia (cp991)
 │  25. MFD - Mazovia - Fido net
 │  26. MIC - Microvex
 │  27. FOR - PC sp. Format
 │  28. PN3 - Polish Norm #3 (Polska Norma #3)
 │  29. SKL - Skalmierski
 │  30. TAG - TAG
 │  31. TEX - TeX.pl
 │  32. VNT - Ventura
 │  33. XJP - XJP Amiga
 │  34. XRD - XRD 2nd edition
 │
 └─────────────────────────────┐
    POSSIBLE ERRORLEVEL VALUES │
 ┌─────────────────────────────┘
 │
 │      0 - No error
 │
 │  PLC internal/user Errors:
 │
 │    241 - Wildcards used in destination filename (/T: switch)
 │    242 - Unknown standard code
 │    243 - Unknown standard code (/S: switch)
 │    244 - File not found (file search)
 │    245 - File not found (proceed)
 │
 │  Dos errors reported by PLC:
 │
 │      1 - Invalid function number
 │      2 - File not found
 │      3 - Path not found
 │      4 - Too many open files
 │      5 - File access denied
 │      6 - Invalid file handle
 │     12 - Invalid file access code
 │     15 - Invalid drive number
 │     16 - Cannot remove current directory
 │     17 - Cannot rename across drives
 │     18 - No more files
 │    100 - Disk read error
 │    101 - Disk write error
 │    102 - File not assigned
 │    103 - File not open
 │    104 - File not open for input
 │    105 - File not open for output
 │    106 - Invalid numeric format
 │    150 - Disk is write-protected
 │    151 - Bad drive request struct length
 │    152 - Drive not ready
 │    154 - CRC error in data
 │    156 - Disk seek error
 │    157 - Unknown media type
 │    158 - Sector Not Found
 │    159 - Printer out of paper
 │    160 - Device write fault
 │    161 - Device read fault
 │    162 - Hardware failure
 │    200 - Division by zero
 │    201 - Range check error
 │    202 - Stack overflow error
 │    203 - Heap overflow error
 │    204 - Invalid pointer operation
 │    205 - Floating point overflow
 │    206 - Floating point underflow
 │    207 - Invalid floating point operation
 │    208 - Overlay manager not installed
 │    209 - Overlay file read error
 │    210 - Object not initialized
 │    211 - Call to abstract method
 │    212 - Stream registration error
 │    213 - Collection index out of range
 │    214 - Collection overflow error
 │    215 - Arithmetic overflow error
 │    216 - General Protection fault
 │
 └────────────────────┐
     AUTO RECOGNIZING │
 ┌────────────────────┘
 │
 │  1. First method (default)
 │
 │    This  method  of  auto recognizing is based on how frequently each of
 │  polish  diacritical  letters  can be found in typical text. I checked a
 │  huge  set  of  different kinds of documents in Polish (18 megabytes) to
 │  obtain  the  best  factors used in auto-recognition module, although it
 │  may  fail  when trying to process a file containing frame-work or ASCII
 │  graphics.  In  such  a  case  you should use /S switch to choose source
 │  standard. I have an idea to make it a bit better but now it's dea only.
 │
 │  2. Alternative method (option '/2')
 │
 │    This method checks every char in a file and if it doesn't exist among
 │  letters  in a standard - the standard gets some 'fail points'. Standard
 │  with the smallest number of 'fail points' is probably standard of file.
 │  This  method  fails  on  docs with framework but can help in particular
 │  cases  (when  whole  file  is  written in uppercase for example). Other
 │  thing  is  that  for  this  algorithm there's no difference between two
 │  standards  of  the  same  charset  in different order (like Mazowia and
 │  Mazowia FIDO).
 │
 │    Note  that  you  can  use  both methods with '/3' option. Result is a
 │  simple average of 1st and 2nd method results.
 │
 └─────────────┐
     BENCHMARK │
 ┌─────────────┘
 │
 │    On  my  Amd  K5  100  MHz  it  takes 02:15 (more than two minutes) to
 │  convert  18  magabytes  long  file (from hard disk to nul device) using
 │  both  standard  analysers  (/3  option).  Converting the same file with
 │  source standard specified (/S: option) takes about 5 seconds - actually
 │  it is FASTER than "copy file.txt nul". Pretty good, huh?
 │
 └────────────┐
     SURPRISE │
 ┌────────────┘
 │
 │    Sometimes you may get a message :
 │  FILE.EXT exist. [O]verwrite [S]kip [R]ename [Q]uit
 │    O - overwrite existing file with new one
 │    S - don't try to convert the file
 │    Q - quit immediately
 │    R - choose a name for EXISTING file, NOT for file that will be saved.
 │
 └───────────┐
     HISTORY │
 ┌───────────┘
 │
 │  1.0 ─ First Release, 8 standards
 │  1.1 ─ Auto-recognizing, /O and /D switches added
 │  1.3 ─ Bugfixed, 14 standards
 │  1.5 ─ Bugfixed, 18 standards [no release]
 │  2.0 ─ New command line (easier/faster to use), 26 standards
 │  3.0 ─ Auto-recognizing improved, 29 standards
 │  3.1 - 30th standard added [no release]
 │  3.5 ─ Wildcards support added, /S switch added
 │  3.6 - Minor bug fixed, minor display change, 31 standards
 │  3.7 - /A switch added, /T: switch bug fixed, 32 standards
 │  3.8 - fixed bug added in 3.7 :), fixed this text, 33 standards
 │  3.9 - fixed another bug (sorry...), auto-recognizing proofed
 │  4.0 - Percentage show fixed, auto-recognizing proofed again
 │  4.1 - Small fixes, extended proofing used [no release]
 │  4.2 - "I'm alive" indicator fixed to time dependent [no release]
 │  4.3 - 34th standard added [no release]
 │  4.4 - Some floating point code fixed [no release]
 │  4.5 - Some memory optimizations [no release]
 │  5.0 - Alternative method of recognizing implemented (/2 and /3)
 │  5.1 - Code fixed to overleap Borland's CRT bug [no release]
 │  5.2 - Converting speed up (using xlation tables) [no release]
 │  5.3 - /R and /Q switches added, documentation extended
 │
 └────────────┐
     PROBLEMS │
 ┌────────────┘
 │
 │    Known problems you may have using PLC:
 │
 │    ¨  When  using  wildcards  no  more than 5041 files will be converted
 │  (this  is because names of files are stored in an array of size limited
 │  to  64K).  In most cases those 5041 should be enough but if not you can
 │  always use DOS' "for" command (I'm not really sure if it'd help...)
 │
 └────────────────┐
     FUTURE PLANS │
 ┌────────────────┘
 │
 │    ¨ Rewrite whole PLC into c++ (watcom/gcc)
 │    ¨ Third version of standard analyser (I have one pretty good idea but
 │  it's really sophisticated...)
 │    ¨ Unix/linux/vms/aix port
 │    ¨ Unknown standard converter (with this thingy PLC will convert file
 │  in a standard that doesn't match any of known standards)
 │    ¨ windoze port (?)
 │    ¨ source code release (?)
 │
 └────────────────────┐
     BLA, BLA, BLA... │
 ┌────────────────────┘
 │
 │    Feel  free  to  ask  me  any  questions.  Wishes  and bug-reports are
 │  welcome. You can use email (dagoon@friko2.onet.pl) or meet me (nickname
 │  "dagoon")  on  #PolishScene  or  #Trax  (EFNet iRC). I need info on not
 │  supported standards (more, more, MORE!!! ;)
 │
 │    I'd like to thank following people for their support and help
 │    ¨ Pawel "KrawietZ" Krawczyk - author of ConvPL
 │    ¨ Maciej Haudek - author of Witaj (standards info)
 │    ¨ Artur Pietruk (docs)
 │    ¨ Artur Olech (Borland's CRT bug information & additional advices)
 │
 │    You  can  find  latest  version of PLC in SAC archive or in Cryogen's
 │  distro sites (see cryogen.nfo)
 │
 │    If  you  want some theory on standards converting and recognizing (in
 │  polish) - try these articles:
 │    ¨ Wladyslaw Majewski "Z komputerem po polsku", Komputer 10/87
 │    ¨ Marcin Borkowski "Polskie litery", Bajtek 2/91
 │    ¨ Grzegorz Eider "Nieco porzadku", Enter 9/91
 │    ¨ Stanislaw  Weslawski  "Problemy rozpoznawania i konwersji polskich
 │  znakow", Magazyn Amiga 1/97
 │
 │    Lot  of  stuff  for  all  hardware platforms and systems available at
 │  http://sunsite.icm.edu.pl/ogonki
 │
 └───────┐
     TIP │
 ┌───────┘
 │
 │    To get polish version of M$ Windows type: "PLC win.com WIN /O"
 │
 └───────┐
     SAC │
 ┌───────┘
 │
 │    You  can download latest versions of PLC (and other utilities made by
 │  me)  from  Slovak  Antivirus  Center  FTP  sites  (PLC is in /UTILTEXT/
 │  subdirectory). Here is complete list of SAC mirrors:
 │
 │    Poland          ftp.pwr.wroc.pl/pub/pc/sac
 │    Czech Republic  ftp.vse.cz/pub/mirror/ftp.elf.stuba.sk/pc
 │    Germany         ftp.cs.tu-berlin.de/pub/msdos/mirrors/stuba/pc
 │    Hungary         ftp.bke.hu/pub/mirrors/sac
 │    Italy           cert.unisa.it/pub/PC/SAC
 │    Italy           ftp2.itb.it/pub/PC/SAC
 │    Slovakia        ftp.netlab.sk/pub/sac
 │    Slovakia        ftp.sac.sk/pub/sac
 │    Slovakia        ftp.gratex.sk/sac
 │    Slovakia        ftp.uakom.sk/pub/mirrors/sac
 │    Taiwan          ftp.nsysu.edu.tw/PC/SAC
 │    U.S.A.          ftp.cdrom.com/pub/sac
 │
 └───────────┐
     CONTACT │
 ┌───────────┘
 │
 │  Marcin Gryszkalis aka Dagoon of Cryogen
 │  ul.xxxxxxxxxxxxx xx m.xx
 │  xx-xxx Lodz
 │  Poland
 │
 │  email: dagoon@rs.math.uni.lodz.pl
 │
 │  phone: (0-48-42) xxx-xx-xx (CET)
 │
 │  WWW: http://rs.math.uni.lodz.pl/~dagoon
 │                                                                          │
 └──────────────────────────────────────────────────────────────────────────┘

```
