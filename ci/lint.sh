#!/bin/bash

echo "inside $0"

source activate pandas

RET=0

if [ "$LINT" ]; then
    echo "Linting"
    for path in 'api' 'core' 'indexes' 'types' 'formats' 'io' 'stats' 'compat' 'sparse' 'tools' 'tseries' 'tests' 'computation' 'util'
    do
        echo "linting -> pandas/$path"
        flake8 pandas/$path --filename '*.py'
        if [ $? -ne "0" ]; then
            RET=1
        fi

    done
    echo "Linting *.py DONE"

    echo "Linting *.pyx"
    for path in 'window.pyx'
    do
        echo "linting -> pandas/$path"
        flake8 pandas/$path --filename '*.pyx' --select=E501,E302,E203,E226,E111,E114,E221,E303,E128,E231,E126,E128
        if [ $? -ne "0" ]; then
            RET=1
        fi

    done
    echo "Linting *.pyx DONE"

    echo "Check for invalid testing"
    grep -r -E --include '*.py' --exclude nosetester.py --exclude testing.py '(numpy|np)\.testing' pandas
    if [ $? = "0" ]; then
        RET=1
    fi
    echo "Check for invalid testing DONE"

else
    echo "NOT Linting"
fi

exit $RET
