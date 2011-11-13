require 'benchmark'

a = Struct.new(:a, :b, :c).new(1, 2, 3)

Benchmark.bm {|b|
	b.report('b: ') {
		100_000.times {
			a.b
		}
	}

	b.report('[1]: ') {
		100_000.times {
			a[1]
		}
	}
}
