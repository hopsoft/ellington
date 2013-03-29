# First pass at generators
* Still need to setup the command line options `ellington generate station train_wrieck`
* Basic functionality in place

```sh
./pry
#create base dirs; pass in path (otherwise defaults to lib)
include BaseGen
create_base "examples/train_wreck"

include StationGen
# first arg is station name, second is option path (otherwise defaults to lib/)
create_station "first_wreck", "examples/train_wreck/station/"
```
