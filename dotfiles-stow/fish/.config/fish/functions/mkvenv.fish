function mkvenv  --description "Create a new venv in '$VENV_HOME' (uv). Usage: mkvenv name [python-version]"
	if test (count $argv) -lt 1
		echo "To create a new enviroment you must pass on a name for it as an argument D: -> mkvenv [env_name] [python_version]"
		return 1
	end
	set -l py_args
	if test (count $argv) -ge 2
		set py_args --python $argv[2]
	end
	uv venv $py_args $VENV_HOME/$argv[1]; or return 1
	echo "Virtual enviroment '$argv[1]' created :D (install with: uv pip install ...)"
end
