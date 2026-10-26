function rmvenv --description "DELETE a virtual enviroment ;("
	echo "Deleting enviroment $argv[1] >:D"
	rm -rf $VENV_HOME/$argv[1]
end
