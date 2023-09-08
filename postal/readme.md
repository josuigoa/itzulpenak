# POSTAL [WIP]

Dagokion sistema eragileran exekutagarria deskargatu `partxea` direktoriotik:

* Linux-en: patch_postal_linux
* Windows-en: patch_postal_win.exe

Jokoa martxan jartzeko exekutagarria (Linuxen `postal1` eta Windowsen `Postal.exe`) dagoen direktorio berean jarri eta exekutatu. Badaezpada, komeni da komando lerrotik exekutatzea, arazorik baldin badago, ikusi ahal izateko.

Gerta daiteke testu batzuk arraro samar ikustea. Jokoaren exekutagarriaren byte-ak ordezkatzen ditut eta exekutagarria bera ez hondatzeko, aldatutako hitzek berezko hitzen luzera bera izan behar zuten. Adibidez:

* easy -> erraz / GAIZKI
* easy -> aise / ONGI

Ez dut lortzen testu batzuk itzultzea:

* Zailtasunaren konfigurazioan: Medium
* Teklatuaren konfigurazioan: Walk, Strafe, Grenades...

Hitz hauek jostagarritasunean edo istorioaren garapenean ez dute eragin haundirik, beraz, bere horretan utzi ditut.

![](postal.png)

## GARAPENA ETA KONPILAZIOA

Partxea aplikatuko duen programa [V](https://vlang.io) lengoaian dago idatzita eta konpilatzerakoan, ordezkatu beharreko testu fitxategi guztiak exekutagarrian txertatuko dira. Exekutagarri eramangarri bakar bat lortuz.

```
v -prod postal_patch.v
```
