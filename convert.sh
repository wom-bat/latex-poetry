#!/bin/sh
case "$1" in
    *.doc)
	b=`basename "$1" .doc`
	abiword -t "$b".txt "$1"
	;;
    *.txt)
	b=`basename "$1" .txt`
	;;
esac
gawk '
BEGIN { inStanza = 0; }
FNR==1 {
       printf("\\begin{poem}{%s}{15mm}\n", $0)
       print "\\begin{stanza}"
       inStanza=1
       next
}
/^$/ {
        if (inStanza) {
	    print("\\end{stanza}")
	    print ""
	    inStanza=0
	}
	next
     }

     {
	 if (inStanza==0){
	     print("\\begin{stanza}")
             inStanza=1
         }
	 line=$0
	 # Spaces at start of line get converted into something TeX wont eat
	 gsub("^[ 	]*", "\\qquad ", line)
	 # tabs within a line are replaced with a fixed space
	 gsub("	", "\\qquad", line}
	 print line
     }

END {
        if (inStanza){
	    print("\\end{stanza}")
	    print ""
	}
	print("\\end{poem}")
    }' "$b.txt" > "$b.tex"
