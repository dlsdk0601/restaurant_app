open: gen-code
	nix-shell --run 'idea .'

gen-code: setup
	nix-shell --run 'flutter pub run build_runner build'

setup:
	nix-shell --run 'flutter pub get'

watch:
	nix-shell --run 'flutter pub run build_runner watch --delete-conflicting-outputs'

