#!/usr/bin/env bash
# small wrapper function to generate ligo noise signals
# David Wright
# Wed Dec  2 01:03:45 AM EST 2020
 
set -euo pipefail
TPERIOD=10
WFORM="SineGaussian"
QFAC=9
ECC=1
PHASE=90
POL=30
FREQ=150
HRSS="1e-20"
GPSSTART=1000000000
SIGDELAY=5
while getopts "t:f:H:p:" o; do
    case "${o}" in
        t)
            SIGDELAY=${OPTARG}
            if [ ${OPTARG} -ge ${TPERIOD} ]; then
                echo "This time delay is too large.\n"
                exit
            fi
            ;;
        f)
            FREQ=${OPTARG}
            ;;
        H)
            HRSS=${OPTARG}
            ;;
        p)
            POL=${OPTARG}
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
shift $((OPTIND-1))
          
    
lalsim-detector-noise --aligo-zerodet-highpower -s ${GPSSTART} -t ${TPERIOD} > output
# need to use bc below in case of float time delay
# lalsim-burst -w SineGaussian -q ${QFAC} -e ${ECC} -p ${PHASE} -f ${FREQ} -H "${HRSS}" \
#    | lalsim-detector-strain -D H1 -O -p ${POL} -t `echo $GPSSTART + $SIGDELAY | bc` > signal
# lalsim-inject noise signal > output

