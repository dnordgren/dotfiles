#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <wordexp.h>
#include <unistd.h>

char* get_file_path(char type) {
    wordexp_t exp_result;
    wordexp("~/Documents/OBTF/", &exp_result, 0);
    char* base_path = exp_result.we_wordv[0];

    char* file_path = malloc(strlen(base_path) + 10);
    sprintf(file_path, "%s/%s.txt", base_path, type == 'w' ? "work" : "life");

    wordfree(&exp_result);
    return file_path;
}

void execute_and_clean(const char* cmd) {
    FILE* pipe = popen(cmd, "r");
    if (!pipe) return;

    char line[1024];
    int skip_next = 0;

    while (fgets(line, sizeof(line), pipe)) {
        if (strstr(line, "--")) {
            skip_next = 1;
            continue;
        }
        if (skip_next) {
            skip_next = 0;
            continue;
        }
        printf("%s", line);
    }
    pclose(pipe);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: td <w|l> [--all] [--done]\n");
        return 1;
    }

    char type = argv[1][0];
    if (type != 'w' && type != 'l') {
        fprintf(stderr, "First argument must be 'w' or 'l'\n");
        return 1;
    }

    int all_lines = 0;
    int show_done = 0;

    for (int i = 2; i < argc; i++) {
        if (strcmp(argv[i], "--all") == 0) all_lines = 1;
        if (strcmp(argv[i], "--done") == 0) show_done = 1;
    }

    char* file_path = get_file_path(type);
    char cmd[1024];

    // Assumes ripgrep is installed and in PATH
    sprintf(cmd, "rg '%s' %s %s",
        show_done ? "@DONE" : "@TODO",
        all_lines ? "-A 999" : "-A 3",
        file_path);

    // Remove this line to use ripgrep's default output
    execute_and_clean(cmd);

    free(file_path);
    return 0;
}
