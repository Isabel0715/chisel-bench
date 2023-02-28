#!/bin/bash

export BENCHMARK_NAME=grep-2.19
export BENCHMARK_DIR=$CHISEL_BENCHMARK_HOME/benchmark/$BENCHMARK_NAME/merged
# export SRC=$BENCHMARK_DIR/$BENCHMARK_NAME.c
# export ORIGIN_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.origin
# export REDUCED_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.reduced
export ORIGIN_SRC=$BENCHMARK_DIR/$BENCHMARK_NAME.c.origin.c
export DEB_SRC=$BENCHMARK_DIR/$BENCHMARK_NAME.c.debloated.c
export ORIGIN_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.origin
# export REDUCED_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.reduced
export DEB_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.debloated
export TIMEOUT="-k 0.8 0.8"
export LOG=$BENCHMARK_DIR/log.txt


source $CHISEL_BENCHMARK_HOME/benchmark/test-base.sh

function clean() {
  # rm -f $DEB_BIN $LOG file log2
  rm -f file log2
  rm -rf gt-*
  rm -f lists.txt
  return 0
}

function compile() {
  if [[ $1 == "-fsanitize=memory -fsanitize-memory-use-after-dtor" ]]; then
    CFLAGS="-w $1 -lpcre"
  else
    CFLAGS="-w $1 -D __msan_unpoison(s,z) -lpcre"
  fi
  $CC $ORIGIN_SRC $CFLAGS -o $ORIGIN_BIN >&$LOG || exit 1
  $CC $DEB_SRC $CFLAGS -o $DEB_BIN >&$LOG || exit 1
  return 0
}

function desired() {
  { timeout $TIMEOUT $DEB_BIN "a" input2; } >&$LOG || exit 1
  $ORIGIN_BIN "a" input2 >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN "a" -v -H -r input_dir; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN "a" -v -H -r input_dir; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN "1" -h -r input_dir; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN "1" -h -r input_dir; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN -n "si" input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN -n "si" input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN "1" -r input_dir -l; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN "1" -r input_dir -l; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN "1" -r input_dir -L; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN "1" -r input_dir -L; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN "randomtext" -r input_dir -c; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN "randomtext" -r input_dir -c; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN -o [r][a][n][d]* input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN -o [r][a][n][d]* input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN "1" -r input_dir -q; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN "1" -r input_dir -q; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN "1" -r input_dir -s; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN "1" -r input_dir -s; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN -v "a" input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN -v "a" input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN -i "Si" input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN -i "Si" input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN -w "Si" input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN -w "Si" input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN -x "Don't" input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN -x "Don't" input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN -F "randomtext*" input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN -F "randomtext*" input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN -E "randomtext*" input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN -E "randomtext*" input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN "ye " input; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN "ye " input; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN "cold" input; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN "cold" input; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN "not exist" input; } >&$LOG
  { timeout $TIMEOUT $ORIGIN_BIN "not exist" input; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN ^D input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN ^D input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN .$ input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN .$ input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN \^ input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN \^ input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN \^$ input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN \^$ input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN ^[AEIOU] input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN ^[AEIOU] input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN ^[^AEIOU] input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN ^[^AEIOU] input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN -E "free[^[:space:]]+" input2; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN -E "free[^[:space:]]+" input2; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1

  { timeout $TIMEOUT $DEB_BIN -E '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' input; } >&$LOG || exit 1
  { timeout $TIMEOUT $ORIGIN_BIN -E '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' input; } >&log2
  diff -q $LOG log2 >&/dev/null || exit 1
  return 0
}

function desired_disaster() {
  case $1 in
  memory)
    MESSAGE="memory exhausted"
    ;;
  file)
    MESSAGE="write error"
    ;;
  *)
    return 1
    ;;
  esac

  { timeout $TIMEOUT $DEB_BIN "a" input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN "a" -v -H -r input_dir; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN "1" -h -r input_dir; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN -n "si" input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN "1" -r input_dir -l; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN "1" -r input_dir -L; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN "randomtext" -r input_dir -c; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN -o [r][a][n][d]* input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN "1" -r input_dir -q; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN "1" -r input_dir -s; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN -v "a" input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN -i "Si" input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN -w "Si" input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN -x "Don't" input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN -F "randomtext*" input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN -E "randomtext*" input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN "ye " input; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN "cold" input; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN "not exist" input; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN ^D input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN .$ input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN \^ input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN \^$ input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN ^[AEIOU] input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN ^[^AEIOU] input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN -E "free[^[:space:]]+" input2; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  { timeout $TIMEOUT $DEB_BIN -E '\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' input; } >&$LOG
  grep -q -E "$MESSAGE" $LOG || exit 1

  return 0
}

function infinite() {
  r=$1
  /bin/grep "Sanitizer" $LOG >&/dev/null && return 0
  if [[ $r -eq 124 ]]; then # timeout
    return 0
  else
    return 1
  fi
}

function outputcheckerror() {
  r="$1"
  if grep -q -E "$r" $LOG; then
    return 1
  fi
  return 0
}

OPT=("-G" "--basic-regexp" "-P" "--perl-regexp" "-e" "-z" "--null-data"
  "-V" "--version" "--help" "-b" "--byte-offset" "--line-buffered"
  "-a" "--text" "-I" "-R" "--dereference-recursive"
  "-T" "--initial-tab" "-Z" "--null" "-U"
  "-binary" "-u" "--unix-byte-offsets")
function undesired() {
  { timeout $TIMEOUT $DEB_BIN; } >&$LOG
  err=$?
  outputcheckerror "OPTION" && exit 1
  crash $err && exit 1
  { timeout $TIMEOUT $DEB_BIN notexist; } >&$LOG # infite loop
  infinite $r && exit 1
  { $timeout $DEB_BIN notexist1 notexit2 notexist3; } >&$LOG
  err=$?
  outputcheckerror "No such file or directory" && exit 1
  crash $err && exit 1
  { timeout $TIMEOUT $DEB_BIN "weird"; } >&$LOG
  infinite $r && exit 1
  # cheap
  for opt in ${OPT[@]}; do
    { timeout 0.2 $DEB_BIN a $opt input; } >&$LOG
    crash $? && exit 1
  done
  # expensive
  { timeout 0.5 $DEB_BIN a -f input; } >&$LOG
  crash $? && exit 1

  { timeout $TIMEOUT $DEB_BIN a -A input; } >&$LOG
  outputcheckerror "input: invalid context length argument" && exit 1
  crash $err && exit 1
  { timeout $TIMEOUT $DEB_BIN a -B input; } >&$LOG
  outputcheckerror "input: invalid context length argument" && exit 1
  crash $err && exit 1
  { timeout $TIMEOUT $DEB_BIN a -C input; } >&$LOG
  outputcheckerror "input: invalid context length argument" && exit 1
  crash $err && exit 1
  { timeout $TIMEOUT $DEB_BIN a -m input; } >&$LOG
  outputcheckerror "invalid max count" && exit 1
  crash $err && exit 1
  { timeout $TIMEOUT $DEB_BIN a -d input; } >&$LOG
  outputcheckerror "invalid argument" && exit 1
  crash $err && exit 1
  { timeout $TIMEOUT $DEB_BIN a -D input; } >&$LOG
  outputcheckerror "unknown devices method" && exit 1
  crash $err && exit 1

  export srcdir=$BENCHMARK_HOME/tests
  export abs_top_srcdir=$BENCHMARK_HOME
  export PATH_BK=$PATH
  export PATH="$(pwd):$PATH"
  for t in $(find tests/ -maxdepth 1 -perm -100 -type f); do
    { timeout 1 $t; } >&$LOG
    crash $? && exit 1
  done
  export PATH=$PATH_BK
  return 0
}

main
