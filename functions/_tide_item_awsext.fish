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

function _prompt_aws_expire
    set -q AWS_PROFILE && set -l AWS_DEFAULT_PROFILE $AWS_PROFILE
    set -q AWS_REGION && set -l AWS_DEFAULT_REGION $AWS_REGION

    if test -n "$AWS_SESSION_EXPIRATION"
        set aws_minute_expire $(printf '%.f\n' $(math "$(aws-sts --diff $AWS_SESSION_EXPIRATION)/60-1"))
    else 
        set aws_expire $(aws-sts -t $AWS_DEFAULT_PROFILE)
        if test -n "$aws_expire"; 
            set aws_minute_expire $(printf '%.f\n' $(math "$(aws-sts --diff $aws_expire)/60-1"))
        else
            set -U tide_awsext_bg_color 00994C
            _tide_print_item awsext "$awsext_no_time_icon"
            return
        end
    end
    
    if test -z "$aws_minute_expire"
      set -U tide_awsext_bg_color 00994C
      _tide_print_item awsext "$awsext_no_time_icon"
      return
    end
  
    if test "$aws_minute_expire" -lt 0
      set -U tide_awsext_bg_color 8B0000
      set e_icon $awsext_lock_icon
    else if test "$aws_minute_expire" -lt 5
      #   set -Ux tide_awsext_bg_color:FF6347
      set -U tide_awsext_bg_color FF4500
      set e_icon $awsext_time_icon
    else if test "$aws_minute_expire" -lt 10
      set -U tide_awsext_bg_color FF7F50
      set e_icon $awsext_time_icon
    else
      set -U tide_awsext_bg_color 00994C
      set e_icon $awsext_time_icon
    end
    # _p9k_prompt_segment "$0" $e_color white $e_icon 0 '' "${aws_minute_expire//\%/%%}"
    _tide_print_item awsext $e_icon' ' "$aws_minute_expire"
end