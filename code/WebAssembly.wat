;; GitCode Viewer - WebAssembly Text Format
;; Utility functions: byte formatting, string hashing, clamping

(module
  ;; ============ Memory ============

  (memory (export "memory") 1)

  ;; String constants in memory
  ;; offset 0:  " B\0"
  ;; offset 4:  " KB\0"
  ;; offset 8:  " MB\0"
  ;; offset 12: " GB\0"
  (data (i32.const 0)  " B\00")
  (data (i32.const 4)  " KB\00")
  (data (i32.const 8)  " MB\00")
  (data (i32.const 12) " GB\00")

  ;; ============ Math Utilities ============

  ;; clamp_i32(value, min, max) -> i32
  (func $clamp_i32 (export "clamp_i32")
    (param $value i32) (param $min i32) (param $max i32)
    (result i32)
    (i32.min_s
      (i32.max_s (local.get $value) (local.get $min))
      (local.get $max)
    )
  )

  ;; clamp_f64(value, min, max) -> f64
  (func $clamp_f64 (export "clamp_f64")
    (param $value f64) (param $min f64) (param $max f64)
    (result f64)
    (f64.min
      (f64.max (local.get $value) (local.get $min))
      (local.get $max)
    )
  )

  ;; ============ Byte Size Formatting ============

  ;; format_bytes_unit(bytes) -> i32 (offset into memory for unit string)
  (func $format_bytes_unit (export "format_bytes_unit")
    (param $bytes i64)
    (result i32)
    (if (i64.lt_u (local.get $bytes) (i64.const 1024))
      (then (return (i32.const 0)))   ;; " B"
    )
    (if (i64.lt_u (local.get $bytes) (i64.const 1048576))
      (then (return (i32.const 4)))   ;; " KB"
    )
    (if (i64.lt_u (local.get $bytes) (i64.const 1073741824))
      (then (return (i32.const 8)))   ;; " MB"
    )
    (i32.const 12)                    ;; " GB"
  )

  ;; format_bytes_value(bytes) -> f64 (numeric value for display)
  (func $format_bytes_value (export "format_bytes_value")
    (param $bytes i64)
    (result f64)
    (if (i64.lt_u (local.get $bytes) (i64.const 1024))
      (then (return (f64.convert_i64_u (local.get $bytes))))
    )
    (if (i64.lt_u (local.get $bytes) (i64.const 1048576))
      (then (return
        (f64.div
          (f64.convert_i64_u (local.get $bytes))
          (f64.const 1024)
        )
      ))
    )
    (if (i64.lt_u (local.get $bytes) (i64.const 1073741824))
      (then (return
        (f64.div
          (f64.convert_i64_u (local.get $bytes))
          (f64.const 1048576)
        )
      ))
    )
    (f64.div
      (f64.convert_i64_u (local.get $bytes))
      (f64.const 1073741824)
    )
  )

  ;; ============ String Hashing (FNV-1a 32-bit) ============

  ;; fnv1a(ptr, len) -> i32
  (func $fnv1a (export "fnv1a")
    (param $ptr i32) (param $len i32)
    (result i32)
    (local $hash i32)
    (local $i i32)
    (local.set $hash (i32.const 0x811c9dc5))  ;; FNV offset basis
    (local.set $i (i32.const 0))
    (block $break
      (loop $loop
        (br_if $break (i32.ge_u (local.get $i) (local.get $len)))
        (local.set $hash
          (i32.mul
            (i32.xor
              (local.get $hash)
              (i32.load8_u (i32.add (local.get $ptr) (local.get $i)))
            )
            (i32.const 0x01000193)  ;; FNV prime
          )
        )
        (local.set $i (i32.add (local.get $i) (i32.const 1)))
        (br $loop)
      )
    )
    (local.get $hash)
  )

  ;; ============ Scroll Utilities ============

  ;; clamp_scroll(scroll, content_size, viewport_size) -> i32
  (func $clamp_scroll (export "clamp_scroll")
    (param $scroll i32)
    (param $content i32)
    (param $viewport i32)
    (result i32)
    (call $clamp_i32
      (local.get $scroll)
      (i32.const 0)
      (i32.max_s
        (i32.sub (local.get $content) (local.get $viewport))
        (i32.const 0)
      )
    )
  )
)
