# shellcheck shell=bash

################################################################################
# Library of helper functions to be sourced by ci scripts.
################################################################################

# Defaults.
declare -i VERBOSITY=${VERBOSITY:-1}

# Helper functions.
err() {
  echo ERROR: "$*" >&2
}

info() {
  if [[ ${VERBOSITY} -ge 1 ]]; then
    echo INFO: "$*" >&2
  fi
}

warn() {
  if [[ ${VERBOSITY} -ge 1 ]]; then
    echo WARN: "$*" >&2
  fi
}

debug() {
  if [[ ${VERBOSITY} -ge 2 ]]; then
    echo DEBUG: "$*" >&2
  fi
}

finish() {
  declare -ri RC=$?

  if [ ${RC} -eq 0 ]; then
    info "$0" OK
  else
    err "$0" failed with exit code ${RC}
    exit ${RC}
  fi
}

handle_err() {
  declare -ri RC=$?

  # $BASH_COMMAND contains the command that was being executed at the time of the trap
  # ${BASH_LINENO[0]} contains the line number in the script of that command
  err "exit code ${RC} from \"${BASH_COMMAND}\" on line ${BASH_LINENO[0]}"

  exit ${RC}
}

is_ci() {
  # Are we running in hands-free CI?
  [[ -n "${CIRCLECI:-}" ]]
}

# Traps.
# NOTE: In POSIX, beside signals, only EXIT is valid as an event.
#       You must use bash to use ERR.
trap finish EXIT
trap handle_err ERR
