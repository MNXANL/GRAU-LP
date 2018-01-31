antlr -gt mountains.g
echo ""
dlg parser.dlg scan.c
echo ""
if  g++ -w -I /usr/include/pccts -o practica mountains.c scan.c err.c;  then
    echo "COMPILATION SUCCESFUL; EXECUTING PROGRAM"
    echo "****************************************"
    ./practica
else
    echo ""
    echo "COMPILATION HAS FAILED"
    echo "**********************"
fi
