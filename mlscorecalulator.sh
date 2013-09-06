if [ $# -lt 1 ] ; then
    echo "Usage : $0 [Match_ID]"
    exit 255
else
    octave -qf scoreCalculator.m $1
fi