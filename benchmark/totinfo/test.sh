#!/bin/bash

export BENCHMARK_NAME=totinfo
export BENCHMARK_DIR=$CHISEL_BENCHMARK_HOME/benchmark/$BENCHMARK_NAME
export ORIGIN_SRC=$BENCHMARK_DIR/$BENCHMARK_NAME.c.origin.c
export REDUCED_SRC=$BENCHMARK_DIR/$BENCHMARK_NAME.c.debloated.c
export ORIGIN_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.origin
export REDUCED_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.reduced
export TIMEOUT="-k 0.5 0.5"
export LOG=$BENCHMARK_DIR/log.reduced
export INDIR=$BENCHMARK_DIR/n10train
export BENCHMARK_CFLAGS="-lm"

source $BENCHMARK_DIR/test-base.sh

function clean() {
  rm -f $REDUCED_BIN $LOG log.txt
  return 0
}

function desired() {
  echo 0
  { timeout $TIMEOUT $REDUCED_BIN  < $INDIR/12new44 >&$LOG; } 
  $ORIGIN_BIN < $INDIR/12new44 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 1
  { timeout $TIMEOUT $REDUCED_BIN < $INDIR/test331.inc  >&$LOG; } 
  $ORIGIN_BIN < $INDIR/test331.inc >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 2
  { timeout $TIMEOUT $REDUCED_BIN < $INDIR/test30.inc >&$LOG ;} 
  $ORIGIN_BIN  < $INDIR/test30.inc >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 3
  { timeout $TIMEOUT $REDUCED_BIN < $INDIR/jk2AAX.mat >&$LOG  ;} 
  $ORIGIN_BIN < $INDIR/jk2AAX.mat >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 4
  { timeout $TIMEOUT $REDUCED_BIN < $INDIR/test405.inc >&$LOG ;}
  $ORIGIN_BIN < $INDIR/test405.inc >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 5
  { timeout $TIMEOUT $REDUCED_BIN < $INDIR/jkACF.mat >&$LOG  ;} 
  $ORIGIN_BIN < $INDIR/jkACF.mat >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1 
  # cat log.txt
  echo 6
  { timeout $TIMEOUT $REDUCED_BIN < $INDIR/tst2f.mat >&$LOG  ;}  
  $ORIGIN_BIN < $INDIR/tst2f.mat >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt 
  echo 7
  { timeout $TIMEOUT $REDUCED_BIN < $INDIR/test70.inc >&$LOG    ;} 
  $ORIGIN_BIN < $INDIR/test70.inc >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 8
  { timeout $TIMEOUT $REDUCED_BIN  < $INDIR/jkAAW.mat >&$LOG  ;} 
  $ORIGIN_BIN  < $INDIR/jkAAW.mat >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  echo 9
  { timeout $TIMEOUT $REDUCED_BIN < $INDIR/test32.inc  >&$LOG ;}  
  $ORIGIN_BIN < $INDIR/test32.inc  >&log.txt
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