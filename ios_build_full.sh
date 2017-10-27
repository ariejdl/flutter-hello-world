 #!/bin/bash

# we then inject the variable into the appropriate line in
# lib/utils.dart in getCipherParams

# export TRAVIS=true
# unset TRAVIS

if [[ ${TRAVIS+x} ]];
then
  # if TRAVIS is defined we use the TRAVIS encrypted variable
  inject=$ENCRYPTED_TOKEN
else
  # else we use the non-encrypted variable
  inject="key = new Uint8List.fromList([97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112]);"
fi

file="./lib/main.dart"
result=$(grep -RHn --colour=auto "//MATCHTOKEN" --include=${file} .)
array=(${result//:/ })
line=${array[1]}

echo $line
echo $file
echo $inject

perl -pi -e 's/\/\/MATCHTOKEN/'"${inject}"'/ if $. == '"${line}"'' ${file}

cat ${file}

flutter packages get
flutter build ios --no-codesign --release

