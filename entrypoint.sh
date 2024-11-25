#! /bin/bash -e
if [ ! -d /var/jenkins_home/casc_configs ]; then
  cp -r /usr/share/jenkins/ref/casc_configs /var/jenkins_home/
  chmod u=rwx /var/jenkins_home/casc_configs
fi

echo "start JENKINS"
# if 'docker run' first argument start with '--' the user is passing jenkins launcher arguments
if [[ $# -lt 1 ]] || [[ "$1" == "--"* ]]; then
  exec /bin/tini -- /usr/local/bin/jenkins.sh "$@"
fi
exec "$@"