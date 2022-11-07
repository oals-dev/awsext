function _aws_profiles
    if test -r "$AWS_CONFIG_FILE"
        grep --color=never -Eo '\[.*\]' "$AWS_CONFIG_FILE" | sed -E 's/^[[:space:]]*\[(profile)?[[:space:]]*([^[:space:]]+)\][[:space:]]*$/\2/g'
        return
    else if test -r "$HOME/.aws/config"
            grep --color=never -Eo '\[.*\]' "$HOME/.aws/config" | sed -E 's/^[[:space:]]*\[(profile)?[[:space:]]*([^[:space:]]+)\][[:space:]]*$/\2/g'
            return
    end
    return 1
end

complete --command asp --no-files
complete --command asp --arguments '(_aws_profiles)'