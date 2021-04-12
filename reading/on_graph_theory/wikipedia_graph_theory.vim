vorgehen:
links für die jeweilige wikipedia-seite
anschließend analyse (grob), ob sinnvoll für bachelorarbeit

hier übersichtsportal zur graphentheorie
https://de.wikipedia.org/wiki/Portal:Graphentheorie

--

https://de.wikipedia.org/wiki/Graphzeichnen

irrelevant, da es hier nicht um das zeichnen von vorgegebenen räumlichen knoten
geht, sondern um die kunst der besten darstellung anhand von gegebenen knoten
und deren attributen

--

https://de.wikipedia.org/wiki/Graph_(Graphentheorie)

unterteilung der graphen von interesse:
<>	digraphen (directed graph) 
	haben wir offensichtlich nicht, da wir im feature graph ungerichtet sind
<>	multigraphen (mehrere verbindungen zwischen zwei punkten möglich)
	gegenteil zum einfachen graph, welchen wir haben, also irrelevant
	ist eine darstellung als multigraph vorzuziehen? nicht nach dem mergen der
	knoten und deren bearings, nein... 
	darstellung von multigraphen mit kantengewichten realisierbar
<>	hypergraphen sind uninteressant

->	wir haben einen ungerichteten, einfachen graphen, manchmal schlicht genannt

induzierte teilgraphen:
wir bekommen einen teilgraph, indem wir eine teilmenge der knoten des graphen 
nehmen und diese mit allen kanten zwischen diesen knoten aus dem ursprünglichen 
graph verbinden

azyklische bzw zyklische graphen:
irrelevant, da wir einen ungerichteten graphen haben

operationen:
<>	kantenkontraktion
<>	komplementgraphen
sind diese von interesse??

weitere eigenschaften:
<>	färbung/benennung
	jeder kante bzw jedem knoten wird eine farbe bzw ein name zugeordnet
	dies kann mit einer abbildung von der menge der knoten auf die natürlichen
	zahlen realisiert werden
	eine färbung/bennenung ist hilfreich, um über den graphen zu reden
	->	relevant, aber implizit gemacht
<>	gewichtet
	wie gefärbt, nur dass es reellwertige gewichte sein können
<>	abbildungen zwischen graphen
	vielleicht relevant als vergleich zwischen ursprungs- und embedding-graph
	aber eigentlich passiert durch die verschiebung der knoten (was implizit
	das ist was bei der besten embedding suche passiert) nichts relevantes in 
	der hinsicht der zwischengraphischen abbildungen

darstellungen im computer:
<>	adjazenzmatrix
	kompakt bei kompakten graphen (viele kanten)
<>	adjazenzliste
	oft notwendig zum lösen von problemen in linearer zeit
<>	inzidenzmatrix
	eine matrix, die jedem knoten zuordnet, ob dieser knoten teil der kante ist
	linearer speicherplatz bezügliche der kantenanzahl, also gut für sparse 
	graphen

--

https://de.wikipedia.org/wiki/Topologische_Graphentheorie

nicht wirklich relevant, höchstens für formalia beim schreiben und erklärung von
einbettungen (embeddings) als formales verfahren (siehe bezeichnungen und 
sprechweisen)

wir haben wohl einen streckengraphen

ebene darstellung:
haben wir eine ebene darstellung? laut definition hier ist eine ebene 
darstellung eines graphen, wenn ein ebener graph dargestellt wird
-> definition ebener graph von relevanz

ebener graph:
spezielle darstellung in R^2 (also reellwertige tupel, koordinatensystem o.ä.),
ist spezialfall eines euklidischen graphen mit q=2

planarer graph:
darstellung des graphen, ohne dass sich kanten kreuzen
<>	plättbarkeit des graphen prüfen, von relevanz?
<>	kombinatorische und gruppentheoretische beschreibung (siehe links)

siehe vielleicht bedeutende sätze section
plättbarkeit:
<>	satz von wagner und fary

--

https://de.wikipedia.org/wiki/Ebener_Graph

unterschied zwischen ebenen und planaren graphen:
<>	planare graphen sind abstrakte graphen mit der eigenschaft der planarität
<>	ebene graphen sind darstellungen von abstrakten graphen in R^2, also im 
	koordinatensystem

maximal ebene graphen sind durch hinzufügen einer beliebig vorstellbaren (doch
zulässigen) kante anschließend nicht mehr eben

--

https://de.wikipedia.org/wiki/Planarer_Graph

ein planarer graph ist ein graph, der in einer ebene (koordinatensystem) mit 
verbindungslinien als kanten zwischen den knotenpunkten dargestellt werden kann,
sodass sich keine kanten schneiden
<>	ein planarer graph hat also einbettungen, die eben sind (wie schon gesagt 
	ist der unterschied zu ebenen graphen, dass es viele tatsächliche 
	zeichnungen eines planaren graphen geben kann, die nicht eben sind)
<>	die linien sind per definition jordan-kurven, macht aber keinen unterschied
	(satz von wagner und fary)

äquivalente einbettunge:
wenn eine isomorphe abbildung zwischen den rändern der beiden einbettungen gibt

typen von planarität:
<>	maximal planar
	es kann keine kante hinzugefügt werden, ohne dass die planarität verschwindet
<>	fast planar
	durch entfernen einer bestimmten kante wird der graph planar
<>	außerplanar
	die einbettung hat alle knoten auf der äußeren seite der graphenfigur

eigenschaften (nur genannt):
<>	eulerscher polyedersatz
<>	durchschnittliche knotenzahl
<>	planare graphendichte

testen von planarität ist in linearer laufzeit möglich

duale graphen:
hier wird bei einem planaren graphen für jede fläche ein knoten generiert und
diese mit kanten (kurven) verbunden, die jede ursprüngliche kante genau einmal
schneidet
->	dies wäre eine möglichkeit die nord orientierung eines graphen so auf 
	flächen herunterzubrechen und ihre anzahl zu minimieren
	also jede fläche des ursprünglichen planaren graphen bekommt die nord 
	ausrichtung in abhängigkeit der flächengebenden knoten (und deren nord) 
	über einen mittelungsvorgang (wie circular mean)
	dabei werden die anzahl der knoten verringert, wobei die kanten gleich 
	bleiben
	Frage: brauchen wir die kanten dann überhaupt? oder wie viele brauchen wir?

--

https://de.wikipedia.org/wiki/Vollst%C3%A4ndiger_Graph

vollständige graphen sind jene, bei denen alle knoten miteinander verbunden sind

eigenschaften:
<>	K_1 bis K_4 sind planar, alle darüber sind es nicht, da sie K_5 enthalten
<>	für ungerade n
	eulersch, also es gibt einen zyklus, bei dem jede kante genau einmal 
	enthalten ist, der sogenannte eulerkreis
<>	für gerade n 
	nicht eulersch
<>	für n>2 
	vollständige graphen sind immer hamiltonsche graphen, also es gibt 
	hamiltonkreise (ähnlich wie eulerkreise), also einen pfad im graphen, der 
	jeden knoten genau einmal besucht (nicht kanten wie im eulerkreis)
<>	gerichtete vollständige graphen nennt man turniergraphen (siehe wiki)

--

https://de.wikipedia.org/wiki/Clique_(Graphentheorie)

cliquen:
<>	sind teilmengen von knoten im ungerichteten graphen, die untereinander 
	verbunden sind
<>	vollständige graphen sind cliquen der größe der anzahl der knoten
<>	anders gesagt: 
	clique ist eine teilmenge von knoten, die einen vollständigen graphen 
	induzieren

co-cliquen/stabile mengen im komplementgraph sind die knotenmengen im 
ursprungsgraph
stabilitätsproblem ist das gegenteil zum cliquenproblem, auch np-vollständig

probleme:
<>	cliquenproblem (np-vollständiges-problem):
	frage, ob graph eine clique mindestens größe k (variable) hat 
<>	optimierungsproblem dabei (np-äquivalent):
	frage nach der cliquenzahl (anzahl der knoten der größten clique)
<>	suchproblem dabei (np-äquivalent):
	suche nach größten clique

wenn graph bipartit, dann lässt sich die größte clique in polynomieller zeit 
finden

--

https://de.wikipedia.org/wiki/K-partiter_Graph

k-partite graphen sind einfache graphen (siehe oben) die in k disjunkte 
knotenmengen innerhalb jeder menge keine verbindung haben
<>	bipartite graphen für k = 2
<>	k-partitionen müssen nicht eindeutig sein
<>	vollständig k-partit, wenn jeder knoten mit jedem knoten in allen anderen
	teilmengen verbunden ist (zb turan graphen)

eigenschaften:
<>	k-knotenfärbbar, also jeder partitionsklasse wird eine farbe zugeordnet
	->	frage graph k-partit äquivalent zu frage graph k-knotenfärbbar
	und
	->	chromatische zahl ist das kleinste k, sodass graph k-partit
<>	wenn graph k-partit, dann auch immer k+x-partit mit x natürliche zahl und
	k+x kleiner als die knotenzahl

--

https://de.wikipedia.org/wiki/Geometrische_Graphentheorie

von interesse vielleicht die erklärung von euklidischen graphen
->	minimaler spannbaum eines vollständigen euklidischen graphen

###
ist das von interesse? als annäherung an cliquen und deren orientierungen?
###

--

https://de.wikipedia.org/wiki/Spektrum_(Graphentheorie)
https://en.wikipedia.org/wiki/Spectral_graph_theory

könnte interessant sein, nochmal anschauen und die eigenschaften durch
flaschenhals (bottleneck, ungleichung von ...) betrachten

wenn ich es gerade richtig verstehe, kann man aus dem spektrum eines graphen,
welche eine nach größe geordnete liste der eigenwerte der adjazenzmatrix eines
graphen ist, einen graphen über z.B. Hall's Algorithmus (suchen!) generieren
-> siehe Beispiele auf wikipedia

--

http://hduongtrong.github.io/2016/02/10/Spectral-Clustering/
https://www.stat.berkeley.edu/~hhuang/STAT141/SpectralClustering.pdf

--

https://en.wikipedia.org/wiki/Strongly_regular_graph
https://de.wikipedia.org/wiki/Regul%C3%A4rer_Graph

interessanterweise gibt es kein kapitel zu stark regulären graphen...
jedoch sind diese vielleicht, ebenso wie normale reguläre graphen, interessant
für die arbeit, da es hier keine unterteilung in subgraphen gibt, die zu 
bevorzugen ist (durch clustering, bottleneck etc)

--

https://de.wikipedia.org/wiki/Graphentheorie#Teilgebiete_der_Graphentheorie
https://de.wikipedia.org/wiki/Matching_(Graphentheorie)
https://de.wikipedia.org/wiki/Faktor_(Graphentheorie)
https://en.wikipedia.org/wiki/Graph_automorphism#Graph_families_defined_by_their_automorphisms

https://www.youtube.com/watch?v=82zlRaRUsaY&ab_channel=SystemsInnovation
https://en.wikipedia.org/wiki/Graph_theory

https://en.wikipedia.org/wiki/Graph_automorphism#Graph_families_defined_by_their_automorphisms
https://mathworld.wolfram.com/topics/GraphTheory.html
https://mathworld.wolfram.com/GraphSpectrum.html

TODO:
verbinde die spektrale untersuchung der adjazenzmatrix mit dem winkelfehler
zwischen den beiden verbindungen bzw den referenz-nord-richtung unseres graphen
