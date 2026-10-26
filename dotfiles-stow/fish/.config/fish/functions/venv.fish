function venv --description "Ativates a python virtual enviroment in '$VENV_HOME'"
	if test (count $argv) -lt 1
		echo "You have to pass on a valid enviroment (one that exists :) as an argument D: -> venv [env_name]"
		return 1
	end

	set -l target "$VENV_HOME/$argv[1]/bin/activate.fish"

	if test -f $target
		source $target
		echo "Venv '$argv[1]' has been activated :D"
	else
		echo "This doesnt exist :(... You can create a new venv with mkvenv :P"
	end
end

