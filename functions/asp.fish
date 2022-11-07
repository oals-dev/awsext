function asp  
  if test -n "$argv[1]"
    set -gx AWS_DEFAULT_PROFILE $argv[1]
    set -gx AWS_PROFILE $argv[1]
  end

  set -gx AWS_SESSION_EXPIRATION $(aws-sts -t $AWS_DEFAULT_PROFILE)
end