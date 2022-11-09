.PHONY: check gen build dependency clean\

execute: build
	./program

check:
	fstar.exe main.fst

build: gen-ocaml
	ocamlfind ocamlopt -o program  -I gen -package fstarlib -linkpkg gen/*.ml

gen-ocaml:
	rm -rf gen
	mkdir gen
	fstar.exe --codegen OCaml --extract "Main" --odir gen main.fst

clean:
	rm -rf gen
	echo "" > .depend
