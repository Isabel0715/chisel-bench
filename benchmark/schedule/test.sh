#!/bin/bash

export BENCHMARK_NAME=schedule
export BENCHMARK_DIR=$CHISEL_BENCHMARK_HOME/benchmark/$BENCHMARK_NAME
export ORIGIN_SRC=$BENCHMARK_DIR/$BENCHMARK_NAME.c.origin.c
export REDUCED_SRC=$BENCHMARK_DIR/$BENCHMARK_NAME.c.debloated.c
export ORIGIN_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.origin
export REDUCED_BIN=$BENCHMARK_DIR/$BENCHMARK_NAME.reduced
export TIMEOUT="-k 0.5 0.5"
export LOG=$BENCHMARK_DIR/log.txt
export INDIR=$BENCHMARK_DIR/n10train

source $CHISEL_BENCHMARK_HOME/benchmark/test-base.sh

function clean() {
  rm -f $REDUCED_BIN $LOG log.txt
  return 0
}

function desired() {
  #echo 0
  { timeout $TIMEOUT $REDUCED_BIN 2 5 3 < $INDIR/dat541 >&$LOG; } 
  $ORIGIN_BIN 2 5 3 < $INDIR/dat541 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  #echo 1
  { timeout $TIMEOUT $REDUCED_BIN 0 4 0 < $INDIR/tc.22  >&$LOG; } 
  $ORIGIN_BIN 0 4 0 < $INDIR/tc.22 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  #echo 2
  { timeout $TIMEOUT $REDUCED_BIN 0 0 0 < $INDIR/tc.99 >&$LOG ;} 
  $ORIGIN_BIN  0 0 0 < $INDIR/tc.99 >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  #echo 3
  { timeout $TIMEOUT $REDUCED_BIN 5 0 4 < $INDIR/dat217  >&$LOG  ;} 
  $ORIGIN_BIN 5 0 4 < $INDIR/dat217  >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  #echo 4
  { timeout $TIMEOUT $REDUCED_BIN 10  9  8  < $INDIR/lu56    >&$LOG ;}
  $ORIGIN_BIN 10  9  8  < $INDIR/lu56  >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  #echo 5
  { timeout $TIMEOUT $REDUCED_BIN 5  4  9  < $INDIR/lu159   >&$LOG  ;} 
  $ORIGIN_BIN 5  4  9  < $INDIR/lu159  >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1 
  # cat log.txt
  #echo 6
  { timeout $TIMEOUT $REDUCED_BIN 3 4 1 < $INDIR/tc.65  >&$LOG  ;}  
  $ORIGIN_BIN 3 4 1 < $INDIR/tc.65  >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt 
  #echo 7
  { timeout $TIMEOUT $REDUCED_BIN 1 1 < $INDIR/ad.2 >&$LOG    ;} 
  $ORIGIN_BIN 1 1 < $INDIR/ad.2  >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  #echo 8
  { timeout $TIMEOUT $REDUCED_BIN 2 5 1 < $INDIR/dat028  >&$LOG  ;} 
  $ORIGIN_BIN 2 5 1 < $INDIR/dat028  >&log.txt
  diff -q $LOG log.txt >&/dev/null || exit 1
  # cat log.txt
  #echo 9
  { timeout $TIMEOUT $REDUCED_BIN 1  6  7  < $INDIR/lu295  >&$LOG ;}  
  $ORIGIN_BIN 1  6  7  < $INDIR/lu295 >&log.txt
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