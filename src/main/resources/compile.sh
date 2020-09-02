#!/bin/bash

TARGET_DIR=./classes

# 删除目录
if [ -d ${TARGET_DIR} ]; then
    rm -rf ${TARGET_DIR}
fi

# 创建目录
mkdir ${TARGET_DIR}

# tools.jar的路径
TOOLS_PATH=${JAVA_HOME}/lib/tools.jar

# 编译Builder注解以及注解处理器
javac -cp ${TOOLS_PATH} $(find ../java -name "*.java")  -d ${TARGET_DIR}/
echo "success"

# 统计文件 `META-INF/services/javax.annotation.processing.Processor` 的行数
LINE_NUM=$(cat META-INF/services/javax.annotation.processing.Processor | wc -l)
LINE_NUM=$((LINE_NUM+1))
echo ${LINE_NUM}

# 将文件 `META-INF/services/javax.annotation.processing.Processor` 中的内容合并成串，以','分隔
PROCESSORS=$(cat META-INF/services/javax.annotation.processing.Processor | awk '{ { printf $0 } if(NR < "'"${LINE_NUM}"'") { printf "," } }')

# 编译UserDTO.java，通过-process参数指定注解处理器
javac -cp ${TARGET_DIR} -d ${TARGET_DIR} -processor ${PROCESSORS} UserDTO.java

# 反编译静态内部类
javap -cp ${TARGET_DIR} -p UserDTO$UserDTOBuilder

# 运行UserDTO
java -cp ${TARGET_DIR} UserDTO

# 删除目录
rm -rf classes
