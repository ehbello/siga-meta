if echo $HOME | grep -q ull.es && test -d "$HOME/home"; then
	export HOME="$HOME/home"
	export G_HOME="$HOME"
fi
