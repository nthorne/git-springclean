git-springclean
===============

Convenience script to remove local-only branches that are merged into HEAD (eg
local topic branches). See usage for further details.

usage
-----
    $ git-springclean -h
    Usage: git-springclean.sh [OPTIONS]
    
    Remove (potentially) obsolete untracked branches (eg local topic branches).
    Default is to only suggest removal of branches that are merged into HEAD.
    
    Where valid OPTIONS are:
      -h, --help  display usage
      --preview   preview suggested deletions, but do not perform.
      --unmerged  consider branches not merged into HEAD.
      --force     delete a branche irrespective of its merged status.

    $ cd <REPO>
    $ git-springclean.sh
    Do you want to remove branch foobar? y
    Deleted branch foobar (was f00).
