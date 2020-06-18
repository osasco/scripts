#!/bin/bash

if [ -z "$1" ]; then
	echo "Copie e execute o modelo abaixo, alterando os valores desejados:"
	echo
	echo "$0 50=0 100=0 156=0 220=0 311=0 440=0 622=0 880=0 1250=0 1750=0 2500=0 3500=0 5000=0 10000=0 20000=0"
	echo
	exit
fi

LADSPA_SINK="ladspa_out"

B50=0
B100=0
B156=0
B220=0
B311=0
B440=0
B622=0
B880=0
B1250=0
B1750=0
B2500=0
B3500=0
B5000=0
B10000=0
B20000=0

QUIT_LOOP=0
while [ $QUIT_LOOP -eq 0 ]; do
	if [[ $1 =~ ^[0-9]+=-?[0-9]+\.?[0-9]*$ ]]; then
		{ read -d '' BANDA_HZ; }< <(echo "$1" | sed -rn 's/(.+)=.+/\1/p')
		{ read -d '' BANDA_DB; }< <(echo "$1" | sed -rn 's/.+=(.+)/\1/p')

		if (( $(echo "$BANDA_DB < -70" | bc -l) )); then
			echo "Aviso: Valor $BANDA_DB dB para banda $BANDA_HZ Hz é menor que -70 dB e foi ajustado."
			BANDA_DB=-70
		fi
		if (( $(echo "$BANDA_DB > 30" | bc -l) )); then
			echo "Aviso: Valor $BANDA_DB dB para banda $BANDA_HZ Hz é maior que 30 dB e foi ajustado."
			BANDA_DB=30
		fi

		case $BANDA_HZ in
		50)
			B50=$BANDA_DB
			;;
		100)
			B100=$BANDA_DB
			;;
		156)
			B156=$BANDA_DB
			;;
		220)
			B220=$BANDA_DB
			;;
		311)
			B311=$BANDA_DB
                        ;;
		440)
			B440=$BANDA_DB
                        ;;
		622)
			B622=$BANDA_DB
                        ;;
		880)
			B880=$BANDA_DB
                        ;;
		1250)
			B1250=$BANDA_DB
                        ;;
		1750)
			B1750=$BANDA_DB
                        ;;
		2500)
			B2500=$BANDA_DB
                        ;;
		3500)
			B3500=$BANDA_DB
                        ;;
		5000)
			B5000=$BANDA_DB
                        ;;
		10000)
			B10000=$BANDA_DB
                        ;;
		20000)
			B20000=$BANDA_DB
                        ;;
		*)
			echo "Aviso: Banda $BANDA_HZ não faz parte dos valores aceitos e foi ignorada."
			;;
		esac
	else
		echo "Aviso: Parâmetro $1 não está em formato reconhecido e foi ignorado."
	fi

	if [ -n "$2" ]; then
		shift
	else
		QUIT_LOOP=1
	fi
done

echo
echo "   50Hz : $B50 dB"
echo "  100Hz : $B100 dB"
echo "  156Hz : $B156 dB"
echo "  220Hz : $B220 dB"
echo "  311Hz : $B311 dB"
echo "  440Hz : $B440 dB"
echo "  622Hz : $B622 dB"
echo "  880Hz : $B880 dB"
echo " 1250Hz : $B1250 dB"
echo " 1750Hz : $B1750 dB"
echo " 2500Hz : $B2500 dB"
echo " 3500Hz : $B3500 dB"
echo " 5000Hz : $B5000 dB"
echo "10000Hz : $B10000 dB"
echo "20000Hz : $B20000 dB"
echo

echo -n "Obtendo sink ALSA... "
SINK_ALSA=$(pactl list sinks short | sed -rn 's/.+\t(.*)\tmodule-alsa-sink.c.*/\1/p' | head -n1)
if [ -z "$SINK_ALSA" ]; then
	echo "erro..."
	exit 1
else
	echo "$SINK_ALSA."
fi

echo -n "Alterando o sink de todos os streams para $SINK_ALSA... "
pactl list sink-inputs short | grep protocol-native.c | sed -rn 's/([0-9]+).*/\1/p' | xargs -n1 -i% pactl move-sink-input % $SINK_ALSA
echo "OK."


echo -n "Descarregando o módulo ladspa... "
LADSPA_UNLOAD=$(pactl unload-module module-ladspa-sink 2>&1)
if [ -n "$LADSPA_UNLOAD" ]; then
	echo "$LADSPA_UNLOAD."
else
	echo "OK."
fi

echo -n "Carregando o módulo ladspa com os novos parâmetros... "
PA_CMD="load-module module-ladspa-sink sink_name=$LADSPA_SINK master=$SINK_ALSA plugin=mbeq_1197 label=mbeq control=$B50,$B100,$B156,$B220,$B311,$B440,$B622,$B880,$B1250,$B1750,$B2500,$B3500,$B5000,$B10000,$B20000"
pactl $PA_CMD > /dev/null
echo "OK."

echo -n "Alterando o sink de todos os streams para $LADSPA_SINK... "
pactl list sink-inputs short | grep protocol-native.c | sed -rn 's/([0-9]+).*/\1/p' | xargs -n1 -i% pactl move-sink-input % $LADSPA_SINK
echo "OK."

echo
echo $PA_CMD


