#!/bin/bash

BASEDIR=$(realpath $(dirname $0)/..)
COMPOSEDIR="$BASEDIR/compose"
SLEEP_COUNT=10
SLEEP_DURATION=5

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
TICK="\xE2\x9C\x94"

function main {
    cleanup all
    cleanup volumes

    test_container http://localhost:8001/en/login base apache.dev
    test_container http://localhost:8001/en/login base apache.dev apache.prod
    test_container http://localhost:8001/en/login base apache.dev mysql
    test_container http://localhost:8001/en/login base apache.dev apache.prod mysql
    test_container http://localhost:8002/en/login base fpm.dev nginx
    test_container http://localhost:8002/en/login base fpm.prod nginx
    test_container http://localhost:8002/en/login base fpm.dev nginx mysql
    test_container http://localhost:8002/en/login base fpm.prod nginx mysql

    finally 0
}

function finally {
    cleanup all
    cleanup volumes
    exit $1
}

function test_container {
    cleanup kimai
    
    URL=$1
    cmd=$(make_cmd "${@:2}")
    echo -e ${COL_GREEN}${KIMAI} ${@:2}${COL_RESET} starting...
    echo $cmd
    $cmd 2>&1 > /dev/null
    STATUS=$(isready $URL)
    if [ "$STATUS" == "FAILED" ]; then
        echo -e ${COL_RED}Failed:${COL_RESET} $cmd
        finally 1
    fi
    # TODO add some function tests
    echo -e "\n${COL_GREEN}${TICK} Done.\n${COL_RESET}"
}

function isready {
    count=0
    STATUS=$(check_command $1)
    until [ "$STATUS" == 200 ]; do
        >&2 echo -n $STATUS", "
        count=$(( count + 1 ))
        if [ $count -gt $SLEEP_COUNT ]; then
            echo FAILED
            return
        fi
        sleep $SLEEP_DURATION
        STATUS=$(check_command $1)
    done
    >&2 echo -n $STATUS
    echo $STATUS
}

function check_command {
    echo $(curl -L -s -o /dev/null -w "%{http_code}" $1)
}

function cleanup {
    if [ -z "$1" ]; then
        TAG=all
    else
        TAG=$1
    fi

    case $TAG in
        all)
            _cleanup kimai_func_tests_;;
        postfix)
            _cleanup kimai_func_tests_postfix;;
        mysql)
            _cleanup kimai_func_tests_sqldb;;
        kimai)
            _cleanup kimai_func_tests_kimai;;
        volumes)
            for x in $(docker volume ls |grep kimai_func_tests_|awk '{print $1}'); do
                docker volume rm $x > /dev/null 2>&1
            done
    esac
}

function _cleanup {
    if [ -z "$1" ]; then
        echo Cannot run $0 with a target.
        return
    fi

    for x in $(docker ps -a |grep $1|awk '{print $1}'); do
        docker stop $x > /dev/null 2>&1
        docker rm $x > /dev/null 2>&1
    done

}

function make_cmd {
    cmd="docker-compose -p kimai_func_tests --log-level CRITICAL "
    for x in $@; do
        cmd="$cmd -f $COMPOSEDIR/docker-compose.$x.yml"
    done
    cmd="$cmd up -d"
    echo $cmd
}

if [ ! -z "$1" ] && [ -z "$KIMAIS" ]; then
    KIMAIS=$@
fi

for KIMAI in $KIMAIS; do 
    export KIMAI
    main
done
