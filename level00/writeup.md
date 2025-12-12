level00@SnowCrash:/$ find / -user flag00 2>/dev/null
/usr/sbin/john
/rofs/usr/sbin/john
level00@SnowCrash:/$ cat /rofs/usr/sbin/john
cdiiddwpgswtgt

La chaîne de caractères cdiiddwpgswtgt décryptée est :

nottoohardhere

Il s'agit d'un chiffrement de César avec un décalage de +11 (ou ROT15 en sens inverse).

level00@SnowCrash:/usr/sbin$ su flag00
Password: 
Don't forget to launch getflag !
flag00@SnowCrash:~$ getflag
Check flag.Here is your token : x24ti5gi3x0ol2eh4esiuxias