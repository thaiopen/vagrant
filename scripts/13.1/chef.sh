#!/usr/bin/env bash
set -x

rpm --import http://download.opensuse.org/repositories/systemsmanagement:/chef:/11/openSUSE_13.1/repodata/repomd.xml.key
zypper addrepo -n 'Systemsmanagement Chef' http://download.opensuse.org/repositories/systemsmanagement:/chef:/11/openSUSE_13.1/ systemsmanagement-chef

zypper --non-interactive --gpg-auto-import-keys in \
  rubygem-chef

exit 0