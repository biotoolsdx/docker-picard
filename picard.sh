#!/bin/bash
# copy it from https://github.com/bioconda/bioconda-recipes/blob/master/recipes/picard/picard.sh
# and modify it by Chen Yuelong <yuelong.chen@aegicare.com>
# because we know where picard.jar and java is, so it is simpler.
# Picard executable shell script
set -eu -o pipefail

#export LC_ALL=en_US.UTF-8

JAR_DIR=/usr/local/bin
java=/usr/bin/java


# extract memory and system property Java arguments from the list of provided arguments
# http://java.dzone.com/articles/better-java-shell-script
default_jvm_mem_opts="-Xms5g -Xmx5g"
jvm_mem_opts=""
jvm_prop_opts=""
pass_args=""
for arg in "$@"; do
    case $arg in
        '-D'*)
            jvm_prop_opts="$jvm_prop_opts $arg"
            ;;
        '-XX'*)
            jvm_prop_opts="$jvm_prop_opts $arg"
            ;;
         '-Xm'*)
            jvm_mem_opts="$jvm_mem_opts $arg"
            ;;
         *)
	    if [[ ${pass_args} == '' ]] #needed to avoid preceeding space on first arg e.g. ' MarkDuplicates'
            then
                pass_args="$arg"
	    else
                pass_args="$pass_args \"$arg\"" #quotes later arguments to avoid problem with ()s in MarkDuplicates regex arg
            fi
            ;;
    esac
done

if [ "$jvm_mem_opts" == "" ]; then
    jvm_mem_opts="$default_jvm_mem_opts"
fi

pass_arr=($pass_args)
if [[ ${pass_arr[0]:=} == org* ]]
then
    eval "$java" $jvm_mem_opts $jvm_prop_opts -cp "$JAR_DIR/picard.jar" $pass_args
else
    eval "$java" $jvm_mem_opts $jvm_prop_opts -jar "$JAR_DIR/picard.jar" $pass_args
fi
exit