//file management system calls

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>

int main(int argc, char *argv[])
{
    int fd;
    char *filename = "test.txt";
    char *buffer = "Hello, World!";
    char read_buffer[100];
    int read_size;

    // open file
    fd = open(filename, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
    if (fd == -1)
    {
        perror("open");
        exit(1);
    }

    // write to file
    if (write(fd, buffer, strlen(buffer)) == -1)
    {
        perror("write");
        exit(1);
    }

    // read from file
    lseek(fd, 0, SEEK_SET);
    read_size = read(fd, read_buffer, 100);
    if (read_size == -1)
    {
        perror("read");
        exit(1);
    }
    read_buffer[read_size] = '\0';
    printf("Read from file: %s\n", read_buffer);

    // close file
    if (close(fd) == -1)
    {
        perror("close");
        exit(1);
    }

    return 0;
}

//programs using process management system calls

#include <stdio.h>
#include <stdlib.h>

int main(){
    int a, b, c, d;
    int num1 = 20, num2 = 10;
    void *wstatus;

    a = fork();
    if (a==0){
        printf("Parent PPID is %d\n", getppid());
        printf("\nChild PID is %d\n", getpid());
        printf("Addition of %d and %d is %d\n", num1, num2, num1+num2);
    }

    b = fork();
    if (b==0){
        printf("\nParent PPID is %d\n", getppid());
        printf("\nChild PID is %d\n", getpid());
        printf("Subtraction of %d and %d is %d\n", num1, num2, num1-num2);
    }

    c = fork();
    if (c==0){
        printf("\nParent PPID is %d\n", getppid());
        printf("\nChild PID is %d\n", getpid());
        printf("Multiplication of %d and %d is %d\n", num1, num2, num1*num2);
    }

    d = fork();
    if (d==0){
        printf("\nParent PPID is %d\n", getppid());
        printf("\nChild PID is %d\n", getpid());
        printf("Division of %d and %d is %d\n", num1, num2, num1/num2);
    }

    else{
        waitpid(a, &wstatus, 0);
        waitpid(b, &wstatus, 0);
        waitpid(c, &wstatus, 0);
        waitpid(d, &wstatus, 0);
    }
    
    return 0;
}

//program based on multithreaded programming
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

void* fun(void* arg){
    printf("Hello World\n");
    return NULL;
}

int main(){
    pthread_t tid[4];
    for (int i=0; i<4; i++){
        int status = pthread_create(&tid[i], NULL, fun, NULL);
        if (status == 0){
            printf("Thread created successfully\n");
        }
        else{
            printf("Thread %d creation failed\n", i);
            exit(1);
        }
        printf("Thread ID is %ld\n", tid[i]);
    }
    pthread_exit(NULL);
    return 0;
}

//program based on multithreaded programming
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

void* sum(void* arg){
    int *Marks = (int*)arg;
    int sum = 0;

    for(int i = 0; i < 5; i++){
        sum += Marks[i];
    }

    return (void*)sum;
}

int main(){
    int Student1[5] = {9, 8, 9, 7, 6};
    int Student2[5] = {10, 5, 8, 7, 10};
    int result[2];

    pthread_t tid1, tid2;
    pthread_create(&tid1, NULL, sum, (void*)Student1);
    pthread_create(&tid2, NULL, sum, (void*)Student2);
    pthread_join(tid1, (void*)&result[0]);
    pthread_join(tid2, (void*)&result[1]);

    if (result[0] > result[1]){
        printf("Student 1 has scored more marks\n");
    } else {
        printf("Student 2 has scored more marks\n");
    }

    pthread_exit(NULL);
    return 0;

}

//priority scheduling algorithm
#include <stdio.h>
#include <stdlib.h>

int main(){
    int i, j, N, TAT[10], WT[10], pos, temp;
    int Sum_wt=0, Sum_tat=0;
    int AT[10], BT[10], PR[10];

    printf("Enter the number of processes: ");
    scanf("%d", &N);

    for (i=0;i<N;i++){
        printf("Enter the arrival time for process %d: ", i+1);
        scanf("%d", &AT[i]);
        printf("Enter the burst time for process %d: ", i+1);
        scanf("%d", &BT[i]);
        printf("Enter the priority for process %d: ", i+1);
        scanf("%d", &PR[i]);
    }

    for (i=0;i<N;i++){
        pos = i;
        for (j=i+1;j<N;j++){
            if (AT[j] < AT[pos]){
                pos = j;
            }
        }

        temp = AT[i];
        AT[i] = AT[pos];
        AT[pos] = temp;

        temp = BT[i];
        BT[i] = BT[pos];
        BT[pos] = temp;

        temp = PR[i];
        PR[i] = PR[pos];
        PR[pos] = temp;
    }

    WT[0] = 0;
    for (i=1;i<N;i++){
        WT[i] = 0;
        for (j=0;j<i;j++){
            WT[i] += BT[j];
        }
    }

    //display process,priority, arrival time, burst time,total arrival time, waiting time
    printf("\nProcess\tPriority\tArrival Time\tBurst Time\tTotal Arrival Time\tWaiting Time\n");
    for (i=0;i<N;i++){
        printf("P%d\t%d\t\t%d\t\t%d\t\t%d\t\t\t%d\n", i+1, PR[i], AT[i], BT[i], AT[i]+WT[i], WT[i]);
    }

    for (i=0;i<N;i++){
        TAT[i] = BT[i] + WT[i];
        Sum_wt += WT[i];
        Sum_tat += TAT[i];
    }

    printf("\nAverage Waiting Time: %f\n", (float)Sum_wt/N);
    printf("Average Turnaround Time: %f\n", (float)Sum_tat/N);

    return 0;
}

//round robin
#include <stdio.h>
#include <stdlib.h>

int main(){
    int i, j, N, time, remain, count=0, TQ, TAT, WT;
    int sum_wt=0, sum_tat=0, AT[10], BT[10], Temp[10];

    printf("Enter the number of processes: ");
    scanf("%d", &N);
    remain = N;

    for(i=0; i<N; i++){
        printf("Enter the arrival time of process %d: ", i+1);
        scanf("%d", &AT[i]);
        printf("Enter the burst time of process %d: ", i+1);
        scanf("%d", &BT[i]);
        Temp[i] = BT[i];
    }

    printf("Enter the time quantum: ");
    scanf("%d", &TQ);

    //print process, arrival time, burst time, turnaround time, waiting time
    printf("\nProcess\tArrival Time\tBurst Time\tTurnaround Time\tWaiting Time\n");

    for(time=0, i=0; remain!=0;){
        if(Temp[i] <= TQ && Temp[i] > 0){
            time += Temp[i];
            Temp[i] = 0;
            count = 1;
        }
        else if(Temp[i] > 0){
            Temp[i] -= TQ;
            time += TQ;
        }

        if(Temp[i] == 0 && count == 1){
            remain--;
            printf("P[%d]\t%d\t\t%d\t\t%d\t\t%d\n", i+1, AT[i], BT[i], time-AT[i], time-AT[i]-BT[i]);
            sum_tat += time-AT[i];
            sum_wt += time-AT[i]-BT[i];
            count = 0;
        }

        if(i == N-1){
            i = 0;
        }
        else if(AT[i+1] <= time){
            i++;
        }
        else{
            i = 0;
        }
    }

    TAT = sum_tat/N;
    WT = sum_wt/N;

    printf("\nAverage Turnaround Time: %d\n", TAT);
    printf("Average Waiting Time: %d\n", WT);

    return 0;
}

//dining philosopher
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#define N 5
#define THINKING 0
#define HUNGRY 1
#define EATING 2
#define LEFT (i+ N-1) % N
#define RIGHT (i+1) % N
int state[N];
sem_t mutex;
sem_t S[N];

void test(int i){
    if((state[i] == HUNGRY) && (state[LEFT] != EATING) && (state[RIGHT] != EATING)){
        state[i] = EATING;
        sleep(2);
        printf("Philosopher %d takes fork %d and %d\n", i + 1, LEFT + 1, i + 1);
        printf("Philosopher %d is Eating\n", i + 1);
        sem_post(&S[i]);
    }
}

void take_fork(int i){
    sem_wait(&mutex);
    state[i] = HUNGRY;
    printf("Philosopher %d is Hungry\n", i + 1);
    test(i);
    sem_post(&mutex);
    sem_wait(&S[i]);
}

void put_fork(int i){
    sem_wait(&mutex);
    state[i] = THINKING;
    printf("Philosopher %d putting fork %d and %d down\n", i + 1, LEFT + 1, i + 1);
    printf("Philosopher %d is thinking\n", i + 1);
    test(LEFT);
    test(RIGHT);
    sem_post(&mutex);
}

void *philosopher(void *num){
    while(1){
        int *i = num;
        sleep(1);
        take_fork(*i);
        sleep(0);
        put_fork(*i);
    }
}

int main(){
    int i;
    pthread_t thread_id[N];
    sem_init(&mutex, 0, 1);
    for(i = 0; i < N; i++){
        sem_init(&S[i], 0, 0);
    }
    for(i = 0; i < N; i++){
        pthread_create(&thread_id[i], NULL, philosopher, &i);
        printf("Philosopher %d is thinking\n", i + 1);
    }
    for(i = 0; i < N; i++){
        pthread_join(thread_id[i], NULL);
    }
    return 0;
}

//reader writer
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <semaphore.h>
#include <unistd.h>
#define N 5
#define M 5

sem_t mutex, writeblock;
int data = 0, rcount = 0;

void *reader(void *arg)
{
    int f;
    f = ((int)arg);
    sem_wait(&mutex);
    rcount = rcount + 1;
    if (rcount == 1)
        sem_wait(&writeblock);
    sem_post(&mutex);
    printf("Data read by the reader%d is %d\n", f, data);
    sleep(1);
    sem_wait(&mutex);
    rcount = rcount - 1;
    if (rcount == 0)
        sem_post(&writeblock);
    sem_post(&mutex);
}

void *writer(void *arg)
{
    int f;
    f = ((int)arg);
    sem_wait(&writeblock);
    data++;
    printf("Data writen by the writer%d is %d\n", f, data);
    sleep(1);
    sem_post(&writeblock);
}

int main()
{
    int i;
    pthread_t rtid[N], wtid[M];
    sem_init(&mutex, 0, 1);
    sem_init(&writeblock, 0, 1);
    for (i = 0; i < N; i++)
    {
        pthread_create(&rtid[i], NULL, reader, (void *)i);
    }
    for (i = 0; i < M; i++)
    {
        pthread_create(&wtid[i], NULL, writer, (void *)i);
    }
    for (i = 0; i < N; i++)
    {
        pthread_join(rtid[i], NULL);
    }
    for (i = 0; i < M; i++)
    {
        pthread_join(wtid[i], NULL);
    }
    return 0;
}
