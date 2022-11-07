function _awsext_install --on-event awsext_install
    set -U awsext_lock_icon ''
    set -U awsext_time_icon ''
    set -U awsext_no_time_icon ''
    echo "Run the `asp AWS_PROFILE_NAME` command if you want to switch AWS Profile."
end

function _awsext_update --on-event awsext_update
    set -U awsext_lock_icon ''
    set -U awsext_time_icon ''
    set -U awsext_no_time_icon ''
    echo "`awsext` has been updated"
end

function _awsext_uninstall --on-event awsext_uninstall
    echo "`awsext` has been uninstalled"
end