if echo $HOME | grep -q ull.es && test -d "$HOME/home"; then
	export HOME="$HOME/home"
fi
