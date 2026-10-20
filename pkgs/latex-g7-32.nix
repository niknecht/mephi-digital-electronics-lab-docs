# Copyright (c) 2026 Nikita Vitkovskiy
# SPDX-License-Identifier: MIT

{ lib, stdenv, pkgs, ... }:
stdenv.mkDerivation rec{
	name = "latex-g7-32";
	version = "5.0.145";

	src = pkgs.fetchFromGitHub {
		owner = "latex-g7-32";
		repo = "latex-g7-32";
		hash = "sha256-OHq0nR82bcsEHtUweL2xjQkk7J242s1NW9X15KQK40Y=";
		rev = "fa9f9a847c1074c0aee5895872403fb276e15a7b";
		fetchSubmodules = true;
	};

	dontBuild = true;

	# This also patches a smaaaaall line that breaks quarto by redefining subcaption
	installPhase = ''
		dest="$out/share/texmf/tex/latex/latex-g7-32"
    mkdir -p "$dest"
 
    for f in G2-105.sty G7-32.cls G7-32.sty GostBase.clo \
             gosttitleGost7-32.sty gosttitleGostRV15-110.sty \
             ; do
      install -Dm644 "G7-32/tex/$f" "$dest/$f"
    done

		g2_105="$dest/G2-105.sty"
		chmod u+w "$g2_105"
		substituteInPlace "$g2_105" \
			--replace-fail '\newcommand*\subcaption[1]' \
											'\newcommand*\gosttablecaption[1]'

		install -Dm644 "tex/local-minted.sty" "$dest/local-minted.sty"
	'';
}
