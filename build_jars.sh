#!/usr/bin/env bash

JAVA_API_PROJECT=dfgui

while [[ "$1" =~ ^- && ! "$1" == "--" ]]; do case $1 in
  --out )
    shift; out_file=$1
    ;;
  --dir )
    shift; working_dir=$1
    ;;
  --in )
    shift
    while [[ "$1" && ! "$1" =~ ^- ]]; do
	in_files+=($1)
	shift
    done
    ;;
esac; shift; done


#Clean out any existing artifacts
rm -rf ${working_dir}/${JAVA_API_PROJECT}/*

# Assemble/Generate all required Java sources
for i in "${in_files[@]}"; do
    if [[ $i =~ .*\.cdf$ ]]; then
        echo r2_codegen -jp ${JAVA_API_PROJECT} -ojd ${working_dir} $i
    elif [[ $i =~ .*\.java$ ]]; then
	target_dir=${working_dir}/${JAVA_API_PROJECT}/$(dirname ${i#*${JAVA_API_PROJECT}/})
	mkdir -p ${target_dir}
	cp $i ${target_dir}/
    else
	exit 1
    fi
done

# Compile all Java sources
for j in ${working_dir}/${JAVA_API_PROJECT}/**/*.java; do
    echo javac -d ${working_dir} $j 
done

# Create archive
echo jar cf ${out_file} ${working_dir}/${JAVA_API_PROJECT}/**/*.class

