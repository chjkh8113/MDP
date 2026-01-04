# MDP Project Instructions

## Process Rules
- dont kill node.exe process directly
- run frontend on port 4444, if busy find PID using that port and kill it to release
- run backend on port 8181, if busy find PID using that port and kill it to release
- always push changes to github unless user explicitly asks not to

## Deployment
- push to github to trigger github action for deploy on self hosted runner server
- fetch/get data from golang backend api instead of query psql in runner server
- The push to GitHub triggered the runner - deployment is automatic
