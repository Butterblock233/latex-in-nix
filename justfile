set shell := ["nu","-c"]
build:
	nix build

build-templates:
	nix build path:./templates/full --out-link ./templates/full/result
	nix build path:./templates/basic --out-link ./templates/basic/result

build-all:build build-templates

check-result:
	ls **/result

clean:
	rm **/result -rf
