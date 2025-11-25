res.pak fitxategiaren formatua

lehenbiziko 3 bytetan PAK paratzen du
4. byte-an PAK bertsioa dago
hurrengo 4 byte-tan Pak-aren goiburuaren tamaina dago


Goiburuaren byte-ak irakurrita, guk aldatu nahi dugun asset-a non dagoen erraz bilatzen ahal dugu. Goiburu horretan fitxategiaren 'gorputzean' daude byte-n 'aurkibidea' baitago.

- asset-aren izenaren luzera byte batean (adib. 0A)
- asset-aren izena (adib. main.fr.mo)
- edukiaren flag-a (direktorioa bada: 1, posizioaren balioa int beharrean float bada: 2, bertzenaz: 0) (adib. 0)
- asset-aren edukia dagoen posizioa (goiburua bukatzen den puntua 0 izanik)
- asset-aren edukiaren luzera
- asset-aren edukiaren checksum bat