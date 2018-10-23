rmdir %~dp0..\exe\res /S /Q
robocopy %~dp0..\res %~dp0..\exe\res /E
copy %~dp0..\mcs.hl %~dp0..\exe\hlboot.dat /Y