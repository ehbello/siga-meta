if echo $HOME | grep -q ull.es && test -d "$HOME/home"; then
	export HOME="$HOME/home"
	export G_HOME="$HOME"
	export JAVA_TOOL_OPTS="-Djava.util.prefs.userRoot=$HOME"
fi
