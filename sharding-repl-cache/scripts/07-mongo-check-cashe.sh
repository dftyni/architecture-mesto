#!/bin/bash

###
# Проверяем реплики
###

curl -o /dev/null -s -w 'Total: %{time_total}s\n' http://localhost:8080/helloDoc/users

curl -o /dev/null -s -w 'Total: %{time_total}s\n' http://localhost:8080/helloDoc/users
$SHELL