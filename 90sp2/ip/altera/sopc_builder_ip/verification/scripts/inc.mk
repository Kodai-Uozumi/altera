VER2POD = verilog2pod

check: ${MODULE}.pod
	podchecker ${MODULE}.pod

${MODULE}.pod: ${MODULE}.sv
	perl ${SCR_DIR}/${VER2POD} ${MODULE}.sv

${MODULE}.man: ${MODULE}.pod
	pod2man ${MODULE}.pod > ${MODULE}.man

man: ${MODULE}.man
	nroff -man ${MODULE}.man 

${MODULE}.html: ${MODULE}.pod
	pod2html ${MODULE}.pod > ${MODULE}.html

${MODULE}.txt: ${MODULE}.pod
	pod2text ${MODULE}.pod > ${MODULE}.txt

${MODULE}.tex: ${MODULE}.pod
	pod2latex ${MODULE}.pod > ${MODULE}.tex

${MODULE}.pdf: ${MODULE}.tex
	pdflatex ${MODULE}.tex > ${MODULE}.pdf

clean:
	rm -f *.pod *.html *.tex *.txt *.man *.dvi *.tmp
