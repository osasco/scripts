#!/bin/bash

LADSPA_SINK="ladspa_out"

echo -n "Obtendo os parâmetros... "
B1="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B2="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B3="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B4="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B5="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B6="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B7="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B8="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B9="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B10="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B11="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B12="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B13="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B14="$1"
if [ -z "$2" ]; then
	echo "não foram fornecidos 15 parâmetros de entrada."
	exit 255
else
	shift
fi
B15="$1"

if [[ ! $B1 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 1 não é um número válido."
	exit 254
fi
if [[ ! $B2 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 2 não é um número válido."
	exit 254
fi
if [[ ! $B3 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 3 não é um número válido."
	exit 254
fi
if [[ ! $B4 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 4 não é um número válido."
	exit 254
fi
if [[ ! $B5 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 5 não é um número válido."
	exit 254
fi
if [[ ! $B6 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 6 não é um número válido."
	exit 254
fi
if [[ ! $B7 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 7 não é um número válido."
	exit 254
fi
if [[ ! $B8 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 8 não é um número válido."
	exit 254
fi
if [[ ! $B9 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 9 não é um número válido."
	exit 254
fi
if [[ ! $B10 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 10 não é um número válido."
	exit 254
fi
if [[ ! $B11 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 11 não é um número válido."
	exit 254
fi
if [[ ! $B12 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 12 não é um número válido."
	exit 254
fi
if [[ ! $B13 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 13 não é um número válido."
	exit 254
fi
if [[ ! $B14 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 14 não é um número válido."
	exit 254
fi
if [[ ! $B15 =~ ^[+-]?[0-9]+\.?[0-9]*$ ]]; then
	echo "Banda 15 não é um número válido."
	exit 254
fi

echo "OK"

echo
echo "   50Hz : $B1 dB"
echo "  100Hz : $B2 dB"
echo "  156Hz : $B3 dB"
echo "  220Hz : $B4 dB"
echo "  311Hz : $B5 dB"
echo "  440Hz : $B6 dB"
echo "  622Hz : $B7 dB"
echo "  880Hz : $B8 dB"
echo " 1250Hz : $B9 dB"
echo " 1750Hz : $B10 dB"
echo " 2500Hz : $B11 dB"
echo " 3500Hz : $B12 dB"
echo " 5000Hz : $B13 dB"
echo "10000Hz : $B14 dB"
echo "20000Hz : $B15 dB"
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
PA_CMD="load-module module-ladspa-sink sink_name=$LADSPA_SINK master=$SINK_ALSA plugin=mbeq_1197 label=mbeq control=$B1,$B2,$B3,$B4,$B5,$B6,$B7,$B8,$B9,$B10,$B11,$B12,$B13,$B14,$B15"
pactl $PA_CMD > /dev/null
echo "OK."

echo -n "Alterando o sink de todos os streams para $LADSPA_SINK... "
pactl list sink-inputs short | grep protocol-native.c | sed -rn 's/([0-9]+).*/\1/p' | xargs -n1 -i% pactl move-sink-input % $LADSPA_SINK
echo "OK."

echo
echo $PA_CMD
