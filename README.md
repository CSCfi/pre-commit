# pre-commit

# Description

This repository contains a script to run as a git hook for your repositories
(and an installer/deployer script). The hook will lint files changed of type:
- Shell scripts (with Shellcheck)
- Python scripts (with Pylint)
- YAML files (with yamllint)
- JSON files (with jq)

# Installation
The installer will try to take care of the dependecies, if it finds your package
manager correctly. And then copy the pre-commit hook into the corresponding
folder of each git repository it finds ($REPO/.git/hooks).

1 Run:
```bash deploy_pre-commit.sh -r <PATH_TO_YOUR_REPOS> -s pre-commit -m 1```

## Full usage of the installer:
deploy_pre-commit.sh -r|--repositories-folder <REPOSITORIES_FOLDER> -s|--pre-commit-script <PRE_COMMIT_SCRIPT> [-m|--max-depth <MAX_DEPTH>] [-h|--help]


| Option | Description | Default value | Required/optional|
---------|-------------|---------------|------------------|
|-r or --repositories-folder | REPOSITORIES_FOLDER will be examine for git repositories and the pre-commit hook will be added to them.| | Required.|
| -s or --pre-commit-script| PRE_COMMIT_SCRIPT it's a executable or script to run before commits. ||Required.|
|-m or --max-depth| MAX_DEPTH is the depth level it will look for git repositories in the REPOSITORIES_FOLDER. |Default is 3. |Optional.|
| -h or --help | Shows this help.||Optional|
