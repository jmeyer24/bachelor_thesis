Theoretische Seite: 
Frage, wie und in welchem Umfang metrische Information im räumlichen Gedächtnis 
("kognitive Karte") gespeichert 

Algorithmisch dazu:
<>	Wegintegration (Odometrie, Anhang Cheung V)
<>	vollständige Triangulation zwischen bekannten Orten (in der Robotik ist das 
	SLAM)

Psychologisch dazu:
<>	"lokale Metrik", bei der man z.B. Abstände zwischen Orten "kennt", wobei 
	diese aber nicht notwendigerweise die Dreiecksungleichung erfüllen 
	(Anhang Erikson Warren)
<>	Variante: globale Referenzrichtung, nicht aber die korrekten Koordinaten 
	von Orten 
<>	Annahme, dass die bekannten Orte in einem Graphen (ggf auch nur in einer 
	Kette) angeordnet sind

In diesem Kontext Projekte: 
<>	Modellierung eines Experimentes zur Wegintegration:
	feste Orte immer wieder besuchen und Richtungen zu anderen Punkten angeben 
	Theorie dazu würde:
   	<>	von der klassischen Wegintegration ausgehen 
	<>	Ortserkennung als zusätzliches Element mit einbauen
   	Mathematisch:
	<>	multidimensionale Skalierung. Evtl auch Ideen aus der Gridcell-Literatur
<> globale Referenzrichtung:
	Aus einem Navigationsmodell von Tristan Baumann (Anhang Dual Population 
	Coding) existiert eine graphenbasierte Raumrepräsentation, mit Schätzungen 
	dieser globalen Referenzrichtung
   	Richtung variiert mit der Position, so wie wirkliche Raumrepräsentationen 
	<>	Aufgabe:
   		metrischen Einbettung des Graphen finden, die die lokalen Schätzungen 
		der Referenzrichtung gleich macht, indem jeweils lokal gedreht wird
		Scheint mathematisch ziemlich schwierig, wahrscheinlich mit einfachen 
		Graphen anfangen
<>	Projekte zur Entwicklung von Praktikumsversuchen in VR

Quellen:
========

https://pdfs.semanticscholar.org/9eda/2d4391b5026d29ada622062ea4c1db5e256d.pdf
https://pdfs.semanticscholar.org/79d9/bca23e42549252421a7fe8b27498682007df.pdf
+ 4 Paper (pdf's) zu SLAM und anderem
