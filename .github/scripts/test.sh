#!/usr/bin/env bash
set -e

case "${MASTER:-"local"}" in
  local)
    ./mill 'tests[_].test'
    ./mill __.mimaReportBinaryIssues
    ;;
  local-distrib)
    ./mill local-spark-distrib-tests.test ;;
  standalone)
    ./mill standalone-tests.test ;;
  yarn)
    ./mill-in-docker-with-yarn-cluster.sh 'yarn-tests[_].test' ;;
  yarn-distrib)
    ./with-spark-home.sh ./mill-in-docker-with-yarn-cluster.sh yarn-spark-distrib-tests.test ;;
  *)
    echo "Unrecognized master type $MASTER"
    exit 1
    ;;
esac
