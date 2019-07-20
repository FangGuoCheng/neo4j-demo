#!/bin/bash
function myHelp()
{
    echo "--------------------------------------------------"
    echo "输入 task.sh ccf dev"
    echo "    修改src/main/resources/application.yml配置文件"
    echo "    active: dev"
    echo "--------------------------------------------------"
    echo "输入 task.sh kill graph-1.0.jar"
    echo "     杀死 graph-1.0.jar 程序"
    echo "--------------------------------------------------"
    echo "输入 task.sh run graph-1.0.jar"
    echo "      运行 graph-1.0.jar 程序"
    echo "--------------------------------------------------"
    echo "输入 task.sh build 1.0"
    echo "      使用 gradlew 打包程序 打包版本为1.0"
    echo "--------------------------------------------------"
    echo "输入 task.sh cdc 192.168.64.137:1500/neo4j-demo:latest"
    echo "      修改 ./docker/docker-compose.yml 中的 image"
    echo "--------------------------------------------------"
}
# Gradlew 构建
function build()
{
    version=$1
    echo "chmod +x gradlew"
    chmod +x gradlew
    echo "./gradlew build -x test -P NEO4J_DEMO_VERSION=$version"
    ./gradlew build -x test -P NEO4J_DEMO_VERSION=$version
}
# 修改 SpringBoot 配置文件
function changerConfigFile()
{
    value=$1
    echo "sed -i 's/\(active: \)[a-z]*/\1${value}/g' ./src/main/resources/application.yml"
    sed -i 's/\(active: \)[a-z]*/\1'${value}'/g' ./src/main/resources/application.yml
}
# 修改 docker-compose 配置文件
function changerDockerCompose()
{
    value=$1
    echo "sed -i 's/\(image: \).*/\1${value}/g' ./docker-compose.yml"
    sed -i 's?\(image: \).*?\1'${value}'?g' ./docker-compose.yml
}
# 根据名字停止指定进程
function myKill()
{
    name=$1
    echo "Kill the $name"
    PROCESS=$(ps -ef|grep -v $0|grep -v grep |grep $name | awk '{print $2}')
    echo "Kill the pid[$PROCESS]"
    #杀死对应进程
    if [ -z "$PROCESS" ];then
    	echo "\$PROCESS is null"
    else
    	for pid in $PROCESS
    	do
    		echo "Pid is :$pid"
    		kill -9 $pid
    	done
    fi
}
# 运行指定 jar 包,并将运行日志输出到当前目录中
function myRun()
{
    name=$1
    # 在 jenkins 中后台执行命令(&) 需要后执行后在执行有输出的命令
    nohup java -Xms4048m -Xmx4048m -jar $1 > ${1%.*}.log 2>&1 &
    # 以下两条命令,不可以删除
    # 删除的后果是nohup java -Xms4048m -Xmx4048m -jar $1 > ${1%.*}.log 2>&1 & 执行无效
    sleep 20
    # 输出当前 jar 包程序日志的前1000条
    tail -n 1000 ${1%.*}.log
}
task_name=$1
echo Task name is $1
case $task_name in
    help)
        myHelp
    ;;
    build)
        echo "task.sh build $2"
        build $2
    ;;
    ccf)
        echo "task.sh changerConfigFile $2"
        changerConfigFile $2
    ;;
    kill)
        echo "task.sh kill $2"
        myKill $2
    ;;
    run)
        echo "task.sh run $2"
        myRun $2
    ;;
    cdc)
        echo "task.sh changerDockerCompose $2"
        changerDockerCompose $2
    ;;
    *)
        echo "This is Default"
esac