TARGET=book

all: ${TARGET}-book.pdf

${TARGET}.pdf: ${TARGET}.ind
	pdflatex ${TARGET}.tex

${TARGET}.ind: ${TARGET}.tex
	pdflatex ${TARGET}.tex
	makeindex -L ${TARGET}.idx
	rm ${TARGET}.pdf

${TARGET}-book.pdf: ${TARGET}.pdf
	./to-book ${TARGET}.pdf
clean:
	rm -f *.aux *.log *.idx *.ind
clobber: clean
	rm -f ${TARGET}.pdf

dependencies: ${TARGET}.tex
	echo "${TARGET}.ind: foreword.tex\\" > $@
	for x in ${TARGET}.tex poems.tex ; do \
	sed -n -e 's/%.*//' -e 's/\\input{\(.*\)}/\1.tex\\/p' $$x >> $@;\
	sed -n -e 's/%.*//' -e 's/\\include{\(.*\)}/\1.tex\\/p' $$x >> $@;\
	done
-include  dependencies
