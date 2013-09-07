MLCricketScorePredictor
=======================

Use Machine Learning to predict target score in curtailed innings of limited over cricket

- Download and install Octave and Gnuplot.
  http://www.gnu.org/software/octave/download.html
  http://www.gnuplot.info/download.html

- Change permissions of scripts and parseYAMLScorecare (or compile the simple C++ parse). 
  $ chmod 755 parse_scorecards.sh mlscorecalculator.sh

- Run parse_scorecards.sh. Note that it will look for all the ODI/T20 yaml files in the subdirectory ./data/

- The parseYAMLScorecard.cpp program is a simple single purpose parser custom made just for these specific files.
  There are other YAML to CSV, TXT, XML parsers available but they were overkill for this project.

- Once the data is available run the mlscorecalculator.sh script with the match ID.
  $ ./mlscorecalculator.sh 350043