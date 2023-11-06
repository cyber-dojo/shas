
root_dir()
{
  git rev-parse --show-toplevel
}

git_commit_sha()
{
  git rev-parse HEAD
}