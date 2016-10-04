#!/bin/bash -

# vim: filetype=sh

# Set IFS explicitly to space-tab-newline to avoid tampering
IFS=' 	
'

# If found, use getconf to constructing a reasonable PATH, otherwise
# we set it manually.
if [[ -x /usr/bin/getconf ]]
then
  PATH=$(/usr/bin/getconf PATH)
else
  PATH=/bin:/usr/bin:/usr/local/bin
fi

MERGED="--merged"
DELETE="-d"


function usage()
{
  cat <<Usage_Heredoc
Usage: $(basename $0) [OPTIONS]

Remove (potentially) obsolete untracked branches (eg local topic branches).
Default is to only suggest removal of branches that are merged into HEAD.

Where valid OPTIONS are:
  -h, --help  display usage
  --preview   preview suggested deletions, but do not perform.
  --unmerged  consider branches not merged into HEAD.
  --force     delete a branche irrespective of its merged status.

Usage_Heredoc
}

function error()
{
  echo "Error: $@" >&2
  exit 1
}

function parse_options()
{
  while (($#))
  do
    case $1 in
      -h|--help)
        usage
        exit 0
        ;;
      --preview)
        PREVIEW="Yes"
        ;;
      --unmerged)
        MERGED=""
        ;;
      --force)
        DELETE="-D"
        ;;
      *)
        error "Unknown option: $1. Try $(basename $0) -h for options."
        ;;
    esac

    shift
  done
}

function clean_branches()
{
  local _branch

  for _branch in $(git branch $MERGED | egrep -v '^\* ')
  do
    if [[ "$(git branch -r)" != *"origin/$_branch"* ]]
    then
      if [[ -n "$PREVIEW" ]]
      then
        echo " Would have removed $_branch."
      else
        read -p "Do you want to delete branch $_branch? " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]
        then
          git branch $DELETE "$_branch"
        fi
      fi
    fi
  done
}


parse_options "$@"
clean_branches
