#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/param.h>
#include <fcntl.h>
#include "libaio.h"

void xfuzz_test_one(void * data, size_t len)
{
    if(len == 0){
        return;
    }
    int               output_fd, input_fd;
    struct iocb       io, *p=&io;
    struct io_event   e;
    struct timespec   timeout;
    io_context_t      ctx;
    //const char        *content="hello world!";
    size_t content_len = len + 1;
    char * content = (char*)malloc(sizeof(char) * content_len);
    memcpy(content, data, len);
    content[len] = '\0';
    char * input_content = (char*)malloc(sizeof(char) * content_len);
    printf("content : %s\n", content);
    // 1. init the io context.
    memset(&ctx, 0, sizeof(ctx));
    if(io_setup(10, &ctx)){
        printf("io_setup error\n");
        free(content);
        free(input_content);
        return;
    }

    // 2. try to open a file.
    if((output_fd=open("test.txt", O_CREAT| O_WRONLY, 0644)) < 0) {
        perror("open error");
        io_destroy(ctx);
        free(content);
        free(input_content);
        return;
    }

    // 3. prepare the data.
    io_prep_pwrite(&io, output_fd, (void*)content, content_len, 0);
    //io.data = content;   // set or not
    if(io_submit(ctx, 1, &p) < 0){
        io_destroy(ctx);
        printf("io_submit error\n");
        free(content);
        free(input_content);
        return;
    }
    // 4. wait IO finish.
    while(1) {
        timeout.tv_sec  = 0;
        timeout.tv_nsec = 500000000; // 0.5s
        if(io_getevents(ctx, 0, 1, &e, &timeout) == 1) {
            close(output_fd);
            break;
        }
        sleep(1);
    }
    //io_destroy(ctx);
    if ((input_fd = open("test.txt", O_RDONLY)) < 0){
        perror("open error");
        io_destroy(ctx);
        free(content);
        free(input_content);
        return;
    }
    io_prep_pread(&io, input_fd, (void*)input_content, content_len, 0);
    if(io_submit(ctx, 1, &p) < 0){
        io_destroy(ctx);
        free(content);
        free(input_content);
        printf("io_submit error\n");
        return;
    }
    while(1) {
        timeout.tv_sec  = 0;
        timeout.tv_nsec = 500000000; // 0.5s
        if(io_getevents(ctx, 0, 1, &e, &timeout) == 1) {
            close(input_fd);
            break;
        }
        sleep(1);
    }
    printf("read data : %s\n", input_content);
    free(content);
    free(input_content);
    remove("test.txt");
    io_destroy(ctx);
    return;
}