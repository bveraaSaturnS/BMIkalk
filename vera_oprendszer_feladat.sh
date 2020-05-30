#!/bin/bash

function help() {
    echo "BMI és ruha méret kalkulátor"
    echo "Használat:"
    echo "    BMI kiszámítása:"
    echo "      $(basename $0) -t testtömeg -m testmagasság -b"
    echo "    Ruha méret meghatározása: "
    echo "      $(basename $0) -t testtömeg -m testmagasság -n f[érfi]|n[ő] -s"
    echo "A tömeget kilogrammban (kg), a magasságot centiméterben (cm) adja meg!"
}

function error_check() {
    if [ -z "$testtomeg" ]; then
        echo "Nem adta meg a testtömeget!"
        exit 1
    fi
    if [ -z "$magassag" ]; then
        echo "Nem adta meg a testmagasságot!"
        exit 1
    fi
}

function BMI() {
    # BMI kiszámolása
    bmi=$(python3 -c "print(round($testtomeg/($magassag ** 2) * 10000, 2))")
    # BMI kiíratás
    echo "Az Ön testtömegindexe: $bmi."
    # konvertálás egésszé
    bmi=$(printf "%.0f\n" $bmi)
    # BMI osztályozás
    if [ "$bmi" -lt 16 ]; then
        echo "Ön súlyosan sovány."
    elif [ "$bmi" -lt 17 ]; then
        echo "Ön mérsékelten sovány."
    elif [ "$bmi" -lt 19 ]; then
        echo "Ön enyhén sovány."
    elif [ "$bmi" -lt 25 ]; then
        echo "Az Ön testtömege normális."
    elif [ "$bmi" -lt 30 ]; then
        echo "Ön túlsúlyos."
    elif [ "$bmi" -lt 35 ]; then
        echo "I. fokú elhízás."
    elif [ "$bmi" -lt 40 ]; then
        echo "II. fokú elhízás."
    else
        echo "III. fokú elhízás."
    fi
}

function size() {
    echo -n "Az Ön ruhamérete: "
    if $ferfi; then
        if [ "$magassag" -ge 155 ] && [ "$magassag" -le 165 ] && [ "$testtomeg" -ge 55 ] && [ "$testtomeg" -le 62 ]; then
            echo -n XS
        elif [ "$magassag" -ge 162 ] && [ "$magassag" -le 175 ] && [ "$testtomeg" -ge 62 ] && [ "$testtomeg" -le 70 ]; then
            echo -n S
        elif [ "$magassag" -ge 170 ] && [ "$magassag" -le 182 ] && [ "$testtomeg" -ge 68 ] && [ "$testtomeg" -le 78 ]; then
            echo -n M
        elif [ "$magassag" -ge 178 ] && [ "$magassag" -le 188 ] && [ "$testtomeg" -ge 78 ] && [ "$testtomeg" -le 85 ]; then
            echo -n L
        elif [ "$magassag" -ge 187 ] && [ "$magassag" -le 197 ] && [ "$testtomeg" -ge 85 ] && [ "$testtomeg" -le 92 ]; then
            echo -n XL
        elif [ "$magassag" -ge 196 ] && [ "$magassag" -le 205 ] && [ "$testtomeg" -ge 92 ] && [ "$testtomeg" -le 100 ]; then
            echo -n XXL
        else
            echo -n "ismeretlen méret"
        fi
        echo "."
    else
        if [ "$magassag" -ge 148 ] && [ "$magassag" -le 155 ] && [ "$testtomeg" -ge 43 ] && [ "$testtomeg" -le 48 ]; then
            echo -n XS
        elif [ "$magassag" -ge 152 ] && [ "$magassag" -le 163 ] && [ "$testtomeg" -ge 48 ] && [ "$testtomeg" -le 55 ]; then
            echo -n S
        elif [ "$magassag" -ge 163 ] && [ "$magassag" -le 172 ] && [ "$testtomeg" -ge 54 ] && [ "$testtomeg" -le 63 ]; then
            echo -n M
        elif [ "$magassag" -ge 172 ] && [ "$magassag" -le 180 ] && [ "$testtomeg" -ge 62 ] && [ "$testtomeg" -le 72 ]; then
            echo -n L
        elif [ "$magassag" -ge 179 ] && [ "$magassag" -le 187 ] && [ "$testtomeg" -ge 70 ] && [ "$testtomeg" -le 78 ]; then
            echo -n XL
        else
            echo -n "ismeretlen méret"
        fi
        echo "."
    fi
}

b=false
s=false
ferfi=true

while getopts "t:m:n:bsh" option; do
    case "$option" in
        t)
            testtomeg=$OPTARG
        ;;
        m)
            magassag=$OPTARG
        ;;
        n)
            if [ $OPTARG = "férfi" ] || [ $OPTARG = "f" ]; then
                ferfi=true
            elif [ $OPTARG = "nő" ] || [ $OPTARG = "n" ]; then
                ferfi=false
            else
                echo "Adjon meg férfi vagy női nemet!"
                exit 1
            fi
        ;;
        h)
            help
            exit
        ;;
        b)
            b=true
        ;;
        s)
            s=true
        ;;
        ?)
            exit 1
    esac
done



if "$b" || "$s" ; then
    error_check
    if "$b"; then
        BMI
    fi
    if "$s"; then
        size
    fi
fi