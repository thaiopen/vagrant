#!/usr/bin/env bash
set -x

rm -f /etc/zypp/repos.d/*.repo

rpm --import http://download.opensuse.org/distribution/13.2/repo/oss/content.key
zypper addrepo -n 'openSUSE OSS' http://download.opensuse.org/distribution/13.2/repo/oss/ distro-oss

rpm --import http://download.opensuse.org/update/13.2/repodata/repomd.xml.key
zypper addrepo -n 'openSUSE OSS Update' http://download.opensuse.org/update/13.2/ distro-update-oss

rpm --import http://download.opensuse.org/distribution/13.2/repo/non-oss/content.key
zypper addrepo -n 'openSUSE Non-OSS' http://download.opensuse.org/distribution/13.2/repo/non-oss/ distro-non-oss

rpm --import http://download.opensuse.org/update/13.2-non-oss/repodata/repomd.xml.key
zypper addrepo -n 'openSUSE Non-OSS Update' http://download.opensuse.org/update/13.2-non-oss/ distro-update-non-oss

RETRIES=7
DELAY=1
FACTOR=2
LOCKED=4

while true
do
  zypper --gpg-auto-import-keys --non-interactive ref

  if [[ $? -ne $LOCKED ]]
  then
    exit $?
  fi

  if [[ $((RETRIES--)) -eq 0 ]]
  then
    echo >&2 "Tries exhausted"
    exit $LOCKED
  fi

  echo >&2 "Sleeping ${DELAY}s"
  sleep $DELAY

  DELAY=$((DELAY * FACTOR))
done

RETRIES=7
DELAY=1
FACTOR=2
LOCKED=4

while true
do
  zypper --gpg-auto-import-keys --non-interactive dup

  if [[ $? -ne $LOCKED ]]
  then
    exit $?
  fi

  if [[ $((RETRIES--)) -eq 0 ]]
  then
    echo >&2 "Tries exhausted"
    exit $LOCKED
  fi

  echo >&2 "Sleeping ${DELAY}s"
  sleep $DELAY

  DELAY=$((DELAY * FACTOR))
done

exit 0