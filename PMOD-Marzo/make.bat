
set CLASSPATH=.;.\java_cup_v10k;%CLASSPATH%

java java_cup.Main -nonterms pmod.cup
javac *.java
