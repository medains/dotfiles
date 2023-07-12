#!/bin/env bash

set -e

unset http_proxy
unset https_proxy
H1="Private-Token: ${GITLAB_TOKEN}"

GITLAB="${GITLAB_HOST}"

MATCH_PATH=$1

pushd () {
    command pushd "$@" > /dev/null
}

popd () {
    command popd "$@" > /dev/null
}

updateGroup() {
    mkdir -p $1

    pushd $1
    GPAGE=1
    while [ $GPAGE -ne 0 ]; do
        RESULT=$(curl -f -H "${H1}" "https://${GITLAB}/api/v4/groups/$2/projects?page=${GPAGE}" 2>/dev/null)
        if [ $? ]; then
            GPAGE=$((GPAGE+1))
            GFOUND=0
            for x in $(echo "${RESULT}" | jq -r 'map("\(.path)=\(.id)") | join(" ")'); do
                GFOUND=1
                id=${x##*=}
                path=${x%=*}
                PROJINFO=$(curl -f -H "${H1}" "https://${GITLAB}/api/v4/projects/${id}" 2>/dev/null)
                PROPERPATH=$(echo "${PROJINFO}" | jq -r '.ssh_url_to_repo')
                if [ "$PROPERPATH" == "git@${GITLAB}:${1}/${path}.git" ]; then
                    if [ ! -d "$path/.git" ]; then
                        echo "$1/$path missing"
                        ! git clone ${PROPERPATH}
                    else
                        pushd $path
                        DEFAULT=$(git remote show origin | fgrep "HEAD branch" | awk '{print $3}')
                        ! git fetch
                        ! git checkout ${DEFAULT}
                        ! git reset --hard origin/${DEFAULT}
                        ! git remote prune origin
                        popd
                    fi
                fi
            done
            if [ $GFOUND -eq 0 ]; then
                GPAGE=0
            fi
        else
            GPAGE=0
        fi
    done
    popd
}

updateGroups() {
    mkdir -p repos
    pushd repos
    PATH_MATCHER="$1*"
    PAGE=1
    while [ $PAGE -ne 0 ]; do
        RESULT=$(curl -f -H "${H1}" "https://${GITLAB}/api/v4/groups?page=${PAGE}" 2>/dev/null)
        if [ $? ]; then
            PAGE=$((PAGE+1))
            FOUND=0
            for x in $(echo "${RESULT}" | jq -r 'map("\(.full_path)=\(.id)") | join(" ")'); do
                id=${x##*=}
                path=${x%=*}
                if [[ $path = $PATH_MATCHER ]]; then
                  echo "updating $path"
                  updateGroup $path $id
                fi
                FOUND=1
            done
            if [ $FOUND -eq 0 ]; then
                PAGE=0
            fi
        else
            PAGE=0
        fi
    done
    popd
}


updateGroups $MATCH_PATH
