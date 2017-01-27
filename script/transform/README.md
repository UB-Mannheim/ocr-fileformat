Scripts should be named `<from>__<to>`, e.g. `hocr-1.0__abbby-10`.

Will be called as

```
/script/transform/<from>__<to> <infile> <outfile> <additional-args>
```

Both `<infile>` and `<outfile>` can be `-`, in which case input should be read
from STDIN or written to STDOUT.
