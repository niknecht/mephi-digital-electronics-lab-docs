# Copyright (c) 2026 Nikita Vitkovskiy
# SPDX-License-Identifier: MIT

final: prev: {
	latex-g7-32 = final.callPackage ./latex-g7-32.nix {};
}
