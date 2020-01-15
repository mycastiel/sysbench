Sysbench - loading data from specified file
====

Sysbench is a popular open source benchmark tool written in C and Lua. It is used to run various MySQL benchmark test. It provides different OLTP workloads, including insert, read / write, read only, write only, update with index and update without index, etc.

Here sysbench code has been modified to support loading data from given text file. Text files can be gerated using tools like [SDGen](https://github.com/AussieGuy0/SDgen), with different compressibilities for MySQL benchmarking.

You can follow README in sysbench folder to build / install sysbench.

1 option is added to support specifying input files for loading data to MySQL tables -

`--table-data-src-file=txt_file_path`

Used along with below option MySQL page copmression can be tested with different data compressibilities.

`--create-table-options={None|lz4|zlib}`

These 2 options are workload options, they need to be added after workload file name in sysbench command line. For an example -

`sysbench /usr/local/share/sysbench/oltp_insert.lua  --create-table-options="compression='zlib'" --table-data-src-file=/home/tcn/compress/normal.txt`


Original Sysbench [README](README.org.md) goes here.