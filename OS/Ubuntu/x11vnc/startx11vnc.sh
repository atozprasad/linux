#!/bin/bash
#ssh -t -L 5900:10.156.134.95:5900 remote-machine 'x11vnc -localhost -display :0'
x11vnc -storepasswd
x11vnc -usepw
