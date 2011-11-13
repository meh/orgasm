require 'benchmark'

a = [1, 2, 3]

Benchmark.bm {|b|
	b.report('first: ') {
		100_000.times {
			a.first
		}
	}

	b.report('[0]: ') {
		100_000.times {
			a[0]
		}
	}
}
