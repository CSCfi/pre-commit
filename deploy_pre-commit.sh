#!/usr/bin/env bash

function usage() {
    echo "$(basename "${0}") -r|--repositories-folder <REPOSITORIES_FOLDER> -s|--pre-commit-script <PRE_COMMIT_SCRIPT> [-h|--help]"
    echo ""
    echo "REPOSITORIES_FOLDER will be examine for git repositories and the pre-commit hook will be added to them."
    echo "PRE_COMMIT_SCRIPT it's a executable or script to run before commits"
}
repositories_folder=""
pre_commit_script=""
max_depth=3
while [ $# -gt 0 ]
do
    case "${1}" in
        '-r'|'--repositories-folder')
            shift
            repositories_folder="${1}"
            shift
            ;;
        '-s'|'--pre-commit-script')
            shift
            pre_commit_script="${1}"
            shift
            ;;
        '-m'|'--max-depth')
            shift
            max_depth="${1}"
            shift
            ;;
        '-h'|'/?'|'-?'|'--help')
            shift
            usage
            exit 0
            ;;
        *)
            echo "Unknown parameter '${1}', ignoring."
            shift
            ;;
    esac
done
if [ ! -e "${repositories_folder}" ] || [ ! -e "${pre_commit_script}" ]; then
    echo "You must indicate a repositories folder and a pre-commit script"
    echo ""
    usage
    exit 1
fi
if [ ! -x "${pre_commit_script}" ]; then
    echo "Set execution permission to pre-commit script '${pre_commit_script}' before deploying it."
    chmod +x "${pre_commit_script}"
fi
installer=""
guess_installer() {
  if [ -z "${installer}" ]; then
    if apt --version; then
      installer='apt install'
    elif yum --version; then
      installer='yum install'
    elif dnf --version; then
      installer='dnf install'
    elif pacman --version; then
      installer='pacman -U'
    elif snap --version; then
      installer='snap install'
    else
      installer='<your-system-installer>'
    fi
  fi
}

guess_installer
${installer} yamllint pylint shellcheck jq

while read -r directory
do
    #echo "Checking directory '${directory}'..."
    if [ -e "${directory}/.git/config" ]; then
        echo "'${directory}' seems to be a git repository, copying '${pre_commit_script}' to '${directory}/.git/hooks/pre-commit'..."
        cp -rfp "${pre_commit_script}" "${directory}/.git/hooks/pre-commit"
    fi
done <<< "$(find "${repositories_folder}" -maxdepth "${max_depth}" -type d | grep -v '/.git/')"
