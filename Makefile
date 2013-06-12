JADE = $(shell find src/*.jade)
HTML = $(patsubst src/%.jade, build/%.html, $(JADE))

all: clean $(HTML)

build/%.html: src/%.jade
	jade < $< --out $< --path $< --pretty > $@

clean:
	rm -f $(HTML)

.PHONY: clean
