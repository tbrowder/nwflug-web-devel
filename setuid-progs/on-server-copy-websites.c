// for local use
// based on:
//   http://www.tuxation.com/setuid-on-shell-scripts.html

/*

The actual shell script to be executed by this programs is:

  cp-incoming-web-site-files.sh

with permissions:

  -rwxr-xr-x  username username

Set permissions for setuid on this program's binary executable:

  $ su
  [enter password]
  # chown root:root binaryprog
  # chmod 4755 binaryprog

Now, you should be able to run it, and you'll see your script being
executed with root permissions. Congratulations!

*/


#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int
main(int argc, char** argv)
{
  if (argc < 2) {
    printf("Usage: %s go\n", argv[0]);
    return 0;
  }

  setuid(0);
  system("./on-server-copy-websites.sh go" );

  return 0;
}
