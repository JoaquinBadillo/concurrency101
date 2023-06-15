defmodule Concurrency101Test do
  use ExUnit.Case
  doctest Hw.Primes

  test "Distinguishing primes" do
    assert 1..10 |> Enum.map(&Hw.Primes.prime?(&1))
      == [false, true, true, false, true, false, true, false, false, false]
    
    assert 1..100_000 |> Enum.filter(&Hw.Primes.prime?(&1)) |> length
      == 9592
  end

  test "Addition correctness" do
    # Calculate results and times
    assert Hw.Primes.sum_primes(5_000_000) == 838_596_693_108
    assert Hw.Primes.sum_primes_parallel(5_000_000) == 838_596_693_108
  end
end
