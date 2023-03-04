#!/bin/bash

export BENCHMARK_NAME=tcas
export BENCHMARK_DIR=$CHISEL_BENCHMARK_HOME/benchmark/$BENCHMARK_NAME
export ORIGIN_SRC=$BENCHMARK_DIR/$BENCHMARK_NAME.c.origin.c
export REDUCED_SRC=$BENCHMARK_DIR/$BENCHMARK_NAME.c.debloated.c
export ORIGIN_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.origin
export REDUCED_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.reduced
export TIMEOUT="-k 0.5 0.5"
export LOG=$BENCHMARK_DIR/log.reduced

source $BENCHMARK_DIR/test-base.sh

function clean() {
  rm -f $REDUCED_BIN $LOG log.txt
  return 0
}

function desired() {
  echo 0
  { timeout $TIMEOUT $REDUCED_BIN 990 1 1 9671 622 173 2 0 766 0 2 1 >&$LOG; } 
  $ORIGIN_BIN 990 1 1 9671 622 173 2 0 766 0 2 1 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 1
  { timeout $TIMEOUT $REDUCED_BIN 700 1 1 575 415 1 0 795 796 2 2 0  >&$LOG; } 
  $ORIGIN_BIN 700 1 1 575 415 1 0 795 796 2 2 0  >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 2
  { timeout $TIMEOUT $REDUCED_BIN 65 0 1 300 700 424 2 600 500 1 1 1 >&$LOG ;} 
  $ORIGIN_BIN  65 0 1 300 700 424 2 600 500 1 1 1 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 3
  { timeout $TIMEOUT $REDUCED_BIN 0 1 -1 0 388 737 3 0 470 0 2 1 >&$LOG  ;} 
  $ORIGIN_BIN 0 1 -1 0 388 737 3 0 470 0 2 1 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 4
  { timeout $TIMEOUT $REDUCED_BIN 775 1 1 1142  411 1704 1  540  500 1 0 1 >&$LOG ;}
  $ORIGIN_BIN 775 1 1 1142  411 1704 1  540  500 1 0 1 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 5
  { timeout $TIMEOUT $REDUCED_BIN 698 1 0 2071 59 307 0 849 904 1 2 0 >&$LOG  ;} 
  $ORIGIN_BIN 698 1 0 2071 59 307 0 849 904 1 2 0 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1 
  # cat log.txt
  echo 6
  { timeout $TIMEOUT $REDUCED_BIN 804 0 1 1933  194 1176 0  640  639 1 0 0 >&$LOG  ;}  
  $ORIGIN_BIN 804 0 1 1933  194 1176 0  640  639 1 0 0 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt 
  echo 7
  { timeout $TIMEOUT $REDUCED_BIN 826 0 0 3619  369 2109 1  741  639 0 1 1 >&$LOG    ;} 
  $ORIGIN_BIN 826 0 0 3619  369 2109 1  741  639 0 1 1 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 8
  { timeout $TIMEOUT $REDUCED_BIN  643 1 1 5514  362 2288 1  400  741 1 1 0 >&$LOG  ;} 
  $ORIGIN_BIN  643 1 1 5514  362 2288 1  400  741 1 1 0 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 9
  { timeout $TIMEOUT $REDUCED_BIN 675 0 0 300 0 424 5 600 500 1 1 1 >&$LOG ;}  
  $ORIGIN_BIN 675 0 0 300 0 424 5 600 500 1 1 1 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  return 0

}

function undesired() {
  # TODO
  return 0
}

function desired_disaster() {
  # TODO
  return 0
}

main