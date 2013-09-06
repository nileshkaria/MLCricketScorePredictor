for ff in $(ls data/*yaml) ; do echo ${ff}; ./parseYAMLScorecard ${ff} ; done
cd data/
for ff in $(ls *_*.txt) ; do echo ${ff}; tail -n+2 ${ff} > temp ; mv temp ${ff} ; done
