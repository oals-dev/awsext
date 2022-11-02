function _tide_item_awsext
    # AWS_PROFILE overrides AWS_DEFAULT_PROFILE, AWS_REGION overrides AWS_DEFAULT_REGION
    set -q AWS_PROFILE && set -l AWS_DEFAULT_PROFILE $AWS_PROFILE
    set -q AWS_REGION && set -l AWS_DEFAULT_REGION $AWS_REGION
    
    set aws_alias $(aws iam list-account-aliases --cli-connect-timeout 3 --query='AccountAliases' --output text 2>/dev/null)
    if test -z "$aws_alias"
        set aws_account $(aws sts get-caller-identity --cli-connect-timeout 3 --query='Account' --output text 2>/dev/null)
    end

    if test -n "$AWS_DEFAULT_PROFILE" && test -n "$aws_alias"
        _tide_print_item aws $tide_aws_icon' ' "$AWS_DEFAULT_PROFILE:$aws_alias"
    else if test -n "$AWS_DEFAULT_PROFILE" && test -n "$aws_account"
        _tide_print_item aws $tide_aws_icon' ' "$AWS_DEFAULT_PROFILE:$aws_account"
    else if test -n "$AWS_DEFAULT_PROFILE"
        _tide_print_item aws $tide_aws_icon' ' "$AWS_DEFAULT_PROFILE"
    end
    _prompt_aws_expire
end

function asp  
  if test -n "$argv[1]"
    set -gx AWS_DEFAULT_PROFILE $argv[1]
    set -gx AWS_PROFILE $argv[1]
  end

  set -gx AWS_SESSION_EXPIRATION $(aws-sts -t $AWS_DEFAULT_PROFILE)
end

function _prompt_aws_expire
    if test -n "$AWS_SESSION_EXPIRATION"
        set aws_minute_expire $(printf '%.f\n' $(math "$(aws-sts --diff $AWS_SESSION_EXPIRATION)/60-1"))
    else 
        set aws_expire $(aws-sts -t $AWS_PROFILE)
        if test -n "$aws_expire"; 
            set aws_minute_expire $(printf '%.f\n' $(math "$aws_expire/60-1"))
        else
            return
        end
    end

  
    if test "$aws_minute_expire" -lt 0
      set e_color 1
      set -U tide_awsext_bg_color 8B0000
      set e_icon $awsext_lock_icon
    else if test "$aws_minute_expire" -lt 5
      set e_color 88
      #   set -Ux tide_awsext_bg_color:FF6347
      set -U tide_awsext_bg_color FF4500
      set e_icon $awsext_time_icon
    else if test "$aws_minute_expire" -lt 10
      set e_color 95
      set -U tide_awsext_bg_color FF7F50
      set e_icon $awsext_time_icon
    else
      set e_color 33
      set e_icon $awsext_time_icon
    end
    # _p9k_prompt_segment "$0" $e_color white $e_icon 0 '' "${aws_minute_expire//\%/%%}"
    _tide_print_item awsext $e_icon' ' "$aws_minute_expire"

end

# parse_iso8601_full() {
#   # arg, like: "2017-11-29T18:52:22+0100"
#   local t
#   typeset -Fg REPLY
#   zmodload zsh/datetime
#   TZ=UTC0 strftime -r -s t %Y-%m-%dT%H:%M:%S%z ${1%.*} &&
#     REPLY=$t
# }

# # Time to expire AWS SESSION
# prompt_aws_expire() {
#   local aws_expire="${AWS_SESSION_EXPIRATION}"

#   if [[ -n "$aws_expire" ]]; then
#     d2=$(date +%Y-%m-%dT%H:%M:%S%z)
#     # d2=$(date +%Y-%m-%dT%H:%M:%SZ)
#     parse_iso8601_full $aws_expire; t1=$REPLY
#     parse_iso8601_full $d2; t2=$REPLY
#     # parse_rfc3339_full $aws_expire; t1=$REPLY
#     # parse_rfc3339_full $d2; t2=$REPLY

#     local aws_minute_expire=$(printf '%.d\n' $(((t1 - t2) / 60 - 1)))
#     if [ "$aws_minute_expire" -lt 0 ]; then
#       e_color=1
#       e_icon='LOCK_ICON'
#     elif [ "$aws_minute_expire" -lt 5 ]; then
#       e_color=88
#       e_icon='EXECUTION_TIME_ICON'
#     elif [ "$aws_minute_expire" -lt 10 ]; then
#       e_color=95
#       e_icon='EXECUTION_TIME_ICON'
#     else
#       e_color=33
#       e_icon='EXECUTION_TIME_ICON'
#     fi
#     # _p9k_prompt_segment "$0" "$2" $e_color white "$aws_minute_expire" $e_icon
#     _p9k_prompt_segment "$0" $e_color white $e_icon 0 '' "${aws_minute_expire//\%/%%}"
#   fi
# }