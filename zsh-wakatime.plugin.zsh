# wakatime for zsh

# hook function to send wakatime a tick
send_wakatime_heartbeat() {
    entity=$(waka_filename);
    project=$(git config --local remote.origin.url|sed -n 's#.*/\([^.]*\)\.git#\1#p');
    if [ "$entity" ]; then
        (wakatime --write --plugin "zsh-wakatime/0.0.1" --entity-type app --project "${project:-Terminal}" --entity "$entity"> /dev/null 2>&1 &)
    fi
}

# generate text to report as "filename" to the wakatime API
waka_filename() {
    if [ "x$WAKATIME_USE_DIRNAME" = "xtrue" ]; then
        # just use the current working directory
        echo "$PWD"
    else
	    cmd="$history[$((HISTCMD-1))]" | cut -d ' ' -f1
	    if [ cmd = "yarn" ]; then
		    echo "$history[$((HISTCMD-1))]" | cut -d ' ' -f1,2
	    else	
	    # only command without arguments to avoid senstive information
            echo $cmd
        fi
    fi
}

precmd_functions+=(send_wakatime_heartbeat)
