function _aws-prompt-fish_install --on-event aws-prompt-fish_install
    set -U aws-prompt_lock_icon '\UE138'
    set -U aws-prompt_time_icon '\UE89C'
    echo "Run the `asp AWS_PROFILE_NAME` command if you want to switch AWS Profile."
end

function _aws-prompt-fish_update --on-event aws-prompt-fish_update
    echo "`aws-prompt-fish` has been updated"
end

function _aws-prompt-fish_uninstall --on-event aws-prompt-fish_uninstall
    echo "`aws-prompt-fish` has been uninstalled"
end