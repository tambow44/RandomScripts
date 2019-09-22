#include <stdio.h>

#define FIZZ(a) (a % 3)
#define BUZZ(b) (b % 5)

int main(void)
{
   int i, limit;

   printf("Enter limit of FizzBuzz game: ");
    scanf("%d", &limit);

   for (i = 1; i <= limit; i++) {

      if (FIZZ(i) == 0 && BUZZ(i) == 0) {
         printf("FizzBuzz!\n");
      } else if (FIZZ(i) == 0) {
         printf("Fizz!\n");
      } else if (BUZZ(i) == 0) {
         printf("Buzz!\n");
      } else {
         printf("%d\n", i);
      }

   }

   return 0;
}
