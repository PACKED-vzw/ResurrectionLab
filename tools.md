TOOLS USED
==========

## 1. Brunnhilde
- bestaat uit een verzameling van open source tools
- mogelijk om analyse van bestanden te maken van hfs-filesystems (itt droid)
- mogelijk om analyse van bestanden te maken van image files (itt siegfried)
- gebruikt ook de pronom-databank
- gebruikt siegfried om bestanden te analyseren: software, versienummer, mimetype
- plaatst dit in een sqlitedabank (is open source databank --> handig, zo kan je queryen binnen je files)
- virusscan --> zo weet je dat het virusvrij is
- haalt de files eraf --> je kan ze 1 voor 1 bekijken zonder dat de image gemount moet worden
- doet ook vanalle analyses: ongekende files, dubbele files, foute files, etc in csv-rapporten
- analyseert ook de disk met fiwalk (forensic analyse)
- brengt de structuur van de disk in kaart (via het tree commando)
- bespaart werk
- nadeel: script moet geschreven worden om images in bulk te analyseren
- nadeel: traag
- test met OB: 1u45 min. heeft het niet kunnen afmaken omdat de batch te groot was voor het CSV-bestand. Daarom werden de CSV-bestanden nog niet gegenereerd, het HTML-rapport en de output van het treecommando.
- is in de eerste plaats een command line tool, maar er is ook een GUI voorzien (link github)

## 2. Droid
- ontwikkeld door National Archives UK
- pronom databank
- csv export
- analyse van bestanden: software, versienummer, duidt fouten aan
- kan iso-bestanden in bulk analyseren: analyseert zowel de container als de bestanden
- nadeel: kan geen hfs-filesystem images lezen, kan enkel de container identificeren
- heeft een gui
- analyseert bestanden op basis van signature
- test met OB: doet 17 minuten over. heeft alles kunnen processen.

## 3. Siegfried
- pronom databank
- csv en json export
- kan geen bestanden in een image lezen, kan enkel de container analyseren
- command line tool
- accuraat omdat zowel bytes als extensie gelezen worden
- duidt fouten aan
- analyseert bestanden op basis van signature en geeft ook aan in welke bytes die signature gevonden werd
- als er geen signature gevonden is, geeft hij een suggestie op basis van extensie
- test met OB: doet er 21 minuten over en heeft alles kunnen processen.

## 4. file
- builtin tool voor unix systemen
- command line tool
- geeft identificatie van het bestandtype, maar is soms minder accuraat en precies als bovenstaande tools
- kan soms wel verrassend veel info geven, zoals met welke applicatie een document aangemaakt werd
- wel snel
- kan niet recursive werken (dus niet in de inhoud van mappen, tenzij je een script maakt).

## 5. fiwalk
- forensic analyse van de disk (high level), o.a. info over filesystemtype
- is niet zo accuraat als disktype, kan dingen niet lezen die disktype wel kan lezen
- mmls kan dan een optie zijn
- gui
- trager dan disktype

## 6. disktype
- builtin command line tool voor unixsystemen
- analyseert het filesystemtype
- zeer accuraat en rijke informatie
- beter dan fiwalk voor dit

## 7. MMLS
- builtin command line tool
- displays the partition layout of a volume system (partition tables)
- gives start and end of each sector (partition)
- disktype gives more detailed information
- is used to list the partition table contents so that you can determine where each partition starts. can be handy when manually imaging a partition with dd, but isn't necessary for analysing in case of emulation.
- fast 

## 8. FIDO
- ontwikkeld door open preservation coalition
- minder accuraat; maakt regelrechte fouten met disk image files. denkt bv. dat de bestanden met .cdr-extensie Corel Draw bestanden zijn
- checkt vaak op extensie en minder op signature
- supertraag
- minder accuraat dan bv. Siegfried en Droid. Siegfried en Droid analyseren een document als Pagemaker; FIDO spreekt van OLE2 Compound Document Format
- FIDO kan EXIF informatie lezen; kan bv. zeggen of een TIFF little of big endian is
- maakt ook regelrechte fouten met XML files zonder header. geeft vier mogelijkheden, waarvan geen enkele juist is. droid en siegfried herkennen dit niet.
- vermoedelijk gebaseerd op file

## 9. FITS
- ontwikkeld door Harvard university
- bestaat uit verschillende open source identificatie en validatie tools, o.m. DROID, Exiftool, Apache Tika, Jhove, Mediainfo, File etc.
- geeft een XML-bestand per bestand
- minder toegankelijk
- relatief snel
- voordeel: validatie en identificatie
- extraheert ook technische metadata
- kan niet in de iso-bestanden de bestanden lezen; herkent het iso-bestand, maar bv geen HSF-bestand
- voor puur bestandsidentificatie is deze tool misschien niet nodig, maar zeer geschikt om te gebruiken in een bredere preserveringsplanningproces

## Glossy glossarium
- file signature: een magic nummer of reeks van bytes die gebruikt worden om het bestandstype te identificeren. Is relatief kort en bevindt zich meestal aan het begin van de bitstream.
