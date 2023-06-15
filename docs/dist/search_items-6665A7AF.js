searchNodes=[{"doc":"Author Joaquin Badillo Some utilities and functions to add the prime numbers from $1$ to $N$, both sequentially and in parallel. Finally there is also a benchmarking function that calculates the speed-up when using $p$ cores: $S_p = \\frac{T_1}{T_p},$ where $p$ is the number of processors and $T_p$ is the time taken for the program to execute the prime addition in $p$ processors.","ref":"Hw.Primes.html","title":"Hw.Primes","type":"module"},{"doc":"Calculates the speedup $S_p = \\frac{T_1}{T_p}$ when adding the primes from 1 to last using the given number of cores using the given number of iterations ( iters ). It returns a tuple containing the averages of $T_1$, $T_p$ and $S_p$. To facilitate reading the data, there is also a side effect, during each iteration the times $T_1$ and $T_p$ will be displayed","ref":"Hw.Primes.html#benchmark/3","title":"Hw.Primes.benchmark/3","type":"function"},{"doc":"Determines if the given natural number ( num ) is prime","ref":"Hw.Primes.html#prime?/1","title":"Hw.Primes.prime?/1","type":"function"},{"doc":"If given a tuple {start, last} , adds the prime numbers in the range start to last . If given just a number assumes the range from 1 to the given number.","ref":"Hw.Primes.html#sum_primes/1","title":"Hw.Primes.sum_primes/1","type":"function"},{"doc":"Adds the prime numbers from 1 to last using the given number of cores (by default all the system's cores are used). The load on each core is most definitely not balanced, which leads to possible optimizations. Determining if a number $n$ is prime has a $O(\\sqrt{n})$ complexity and therefore to balance the loads the range of numbers when split should not be sequential.","ref":"Hw.Primes.html#sum_primes_parallel/2","title":"Hw.Primes.sum_primes_parallel/2","type":"function"}]