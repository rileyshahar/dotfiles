main.pdf: main.tex macros.tex
	latexmk -pdf -halt-on-error main.tex

clean:
	-rm -f *.snm *.nav *.vrb *.bbl *.dvi *.ps *.pdf *.run.xml
	latexmk -c
