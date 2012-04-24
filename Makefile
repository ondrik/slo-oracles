###############################################################################
#                                                                             #
#                                    Makefile                                 #
#                        The Makefile for the presentations                   #
#                                                                             #
#                          (C)opyright 2007 Ondrej Lengal                     #
#                             <ondra.lengal@gmail.com>                        #
#                                                                             #
###############################################################################

# Files for deletion
DEL_FILES=*.dvi *.aux *.log *.nav *.out *.snm *.toc
PDF_FILES=slo-oracles

# The TeX program
TEX=pdflatex

# Flags for TeX
TEX_FLAGS=-interaction nonstopmode

# The Fig2Dev conversion program
FIG=fig2dev

# The Dia to Eps conversion program
DIA=dia

# The flags for Dia
DIA_FLAGS=-t eps

# The output flag for Dia
DIA_O=-e

# The Fig2Dev output format
FIG_OUT_FMT=eps

# Flags for Fig2Dev
FIG_FLAGS=-L $(FIG_OUT_FMT)

# The image conversion to PDF program name
IMG_TO_PDF=epstopdf

# The image conversion program output file option
IMG_TO_PDF_OUT=--outfile

# The image PDF file extension
PDF_EXT=pdf

# The default target
all: $(PDF_FILES).pdf

%.pdf: %.tex images schemes
	-$(TEX) $(TEX_FLAGS) $<
	-$(TEX) $(TEX_FLAGS) $<
	rm -f $(DEL_FILES)

images: $(patsubst %.fig,%.$(FIG_OUT_FMT), $(wildcard *.fig))

%.$(FIG_OUT_FMT): %.fig 
	($(FIG) $(FIG_FLAGS) $< $@ ; \
	$(IMG_TO_PDF) $(IMG_TO_PDF_OUT)=$(patsubst %.$(FIG_OUT_FMT),%.$(PDF_EXT), $@) $@)

schemes: $(patsubst %.dia,%.$(FIG_OUT_FMT), $(wildcard *.dia))

%.$(FIG_OUT_FMT): %.dia
	($(DIA) $(DIA_FLAGS) $(DIA_O) $@ $< ; \
	$(IMG_TO_PDF) $(IMG_TO_PDF_OUT)=$(patsubst %.$(FIG_OUT_FMT),%.$(PDF_EXT), $@) $@)

clean:
	rm -f $(DEL_FILES) $(PDF_FILES)

run: $(PDF_FILES)
	xpdf -fullscreen $(PDF_FILES)
