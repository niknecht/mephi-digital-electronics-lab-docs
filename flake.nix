# Copyright (c) 2026 Nikita Vitkovskiy
# SPDX-License-Identifier: MIT

{
  description = "This defines a devalopment enviroment that includes full toolchain support for Quarto Markdown to PDF and related tools.";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
  };
  outputs = { self, nixpkgs, nixpkgs-stable, flake-utils }:
	flake-utils.lib.eachDefaultSystem ( system: 
		let 
			pkgs = import nixpkgs {inherit system; overlays = [(import ./pkgs/overlay.nix)];};
			stable = import nixpkgs-stable { inherit system; overlays = [(import ./pkgs/overlay.nix)]; };

			tex = pkgs.texliveBasic.withPackages (ps: with ps; [
				# GOST G7-32 template dependencies
				amsmath
				caption
				footmisc
				hyperref
				iftex
				underscore
				etoolbox
				lastpage
				titlesec
				amsmath
				mfirstuc
				nomencl
				cm-unicode
				minted
				polyglossia
				xecyr
				xetex
				extsizes
				amsfonts # Includes amssymb
				was # Includes icomma
				graphics # Includes graphicx and color
				tools # Includes longtable and flafter
				graphviz
 				#cm-unicode-fonts # Included by cm-unicode

				# Other dependencies
				xstring # Keep these here or else nothing will compile
				metalogo # Maybe not this one idk
				xltxtra
				realscripts
				bigfoot
				koma-script
				unicode-math
				booktabs
				mdwtools
				greek-fontenc

				#tikz # Included by pgf # UML diagrams, electrical diagrams etc
				babel # (remember - no) russian
				fontspec
				pgf # ???
				dvisvgm
				circuitikz # electrical diagrams
				# quarto dependencies
				#combined.scheme-full
				
			]);
		in {
			devShells.default = pkgs.mkShell {
				packages = with stable; [
					(pkgs.quarto.overrideAttrs (old: {
					postPatch = (old.postPatch or "") + ''
						substituteInPlace bin/quarto.js \
							--replace-fail "syntax-highlighting" "highlight-style"
						'';
					}))
					# Main dependencies nessesary to build the PDF
					#stable.pandoc
					#stable.quarto
				] ++ (with pkgs; [
					# GOST G7-32 template application dependencies
					inkscape
					dia
					python314Packages.pygments
					python314
					python314Packages.pip
					# GOST G7-32
					latex-g7-32
					liberation_ttf # Free fonts
				]) ++ [tex]; # Nah, it was dumber than that. Something like Rex...
				TEXMFHOME = "${pkgs.latex-g7-32}/share/texmf";
			};
	  });
}
