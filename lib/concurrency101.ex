defmodule Hw.Primes do
  @moduledoc """
  ## Author
  Joaquin Badillo
  ---

  Some utilities and functions to add the prime numbers from $1$ to $N$,
  both sequentially and in parallel. Finally there is also a benchmarking
  function that calculates the speed-up when using $p$ cores:
  $S_p = \\frac{T_1}{T_p},$
  where $p$ is the number of processors and $T_p$ is the time taken for the program
  to execute the prime addition in $p$ processors.
  """

  @doc """
  Determines if the given natural number (`num`) is prime
  """
  def prime?(num) when num < 2,
      do: false

  def prime?(num), 
      do: do_prime?(2, num, :math.sqrt(num))

  defp do_prime?(i, _num, bound) when i > bound, 
      do: true
  
  defp do_prime?(i, num, bound) do
      if rem(num, i) == 0, do: false, 
      else: do_prime?(i + 1, num, bound)
  end
  
  @doc """
  If given a tuple `{start, last}`, adds the prime numbers in the range `start` to `last`. 
  If given just a number assumes the range from 1 to the given number.
  """
  def sum_primes({start, last}), 
      do: do_sum_primes(start, last, 0)
  
  def sum_primes(val),
      do: do_sum_primes(1, val, 0)

  defp do_sum_primes(current, last, acc) when current > last, 
      do: acc       

  defp do_sum_primes(current, last, acc) do
      new_acc = if prime?(current), do: acc + current, else: acc
      do_sum_primes(current + 1, last, new_acc)
  end

  @doc """
  Adds the prime numbers from 1 to `last` using the given number of `cores`
  (by default all the system's cores are used).

  The load on each core is most definitely not balanced, which leads to possible
  optimizations. Determining if a number $n$ is prime has a $O(\\sqrt{n})$ complexity
  and therefore to balance the loads the range of numbers when split should not be 
  sequential.
  """
  def sum_primes_parallel(last, cores \\ System.schedulers) do
      make_ranges(1, last, cores)
      |> Enum.map(&Task.async(fn -> sum_primes(&1) end))
      |> Enum.map(&Task.await(&1, :infinity))
      |> Enum.sum
  end

  @doc """
  Calculates the speedup $S_p = \\frac{T_1}{T_p}$ when adding the primes from 1 to `last`
  using the given number of `cores` using the given number of iterations (`iters`). 
  It returns a tuple containing the averages of $T_1$, $T_p$ and $S_p$.

  To facilitate reading the data, there is also a side effect, during each iteration the
  times $T_1$ and $T_p$ will be displayed
  """
  def benchmark(last, cores \\ System.schedulers, iters \\ 10) do
      {acc_1, acc_p} = do_benchmark(last, cores, {0, 0}, iters)
      {acc_1 / iters, acc_p / iters, acc_1 / acc_p} 
  end

  # Utility function to time sequential and parallel executions
  defp do_benchmark(_last, _cores, acc, 0), 
    do: acc

  defp do_benchmark(last, cores, {acc_1, acc_p}, iters) do
    t1 = :timer.tc(fn -> Hw.Primes.sum_primes(last) end) 
      |> elem(0)
      |> Kernel./(1_000_000)

    tp = :timer.tc(fn -> Hw.Primes.sum_primes_parallel(last, cores) end) 
      |> elem(0)
      |> Kernel./(1_000_000)
    
    IO.puts(~s(T1: #{t1}\t | \t T#{cores}: #{tp}))

    do_benchmark(last, cores, {acc_1 + t1, acc_p + tp}, iters - 1)
  end

  # Utility function to split ranges
  defp make_ranges(start, finish, cores) do
      size = div(finish - start + 1, cores)
      remainder = rem(finish - start + 1, cores)
      do_make_ranges(start, size, remainder , cores, [])
  end

  # There is no need to reverse the result, addition is conmutative
  defp do_make_ranges(s, size, _r, 1, res),
      do: [{s, s + size - 1} | res]
  
  # Since the time complexity depends on the size of the numbers, it makes sense to
  # increase the load on the first block instead of the last
  defp do_make_ranges(s, size, r, iter, []),
      do: do_make_ranges(s + size + r, size, r, iter - 1, [{s, s + r + size - 1}])

  defp do_make_ranges(s, size, r, iter, res), 
      do: do_make_ranges(s + size, size, r, iter - 1, [{s, s + size - 1} | res]) 
end
